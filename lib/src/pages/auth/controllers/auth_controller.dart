import 'package:get/get.dart';
import 'package:greengrocer/src/constants/storage_keys.dart';
import 'package:greengrocer/src/models/user_model.dart';
import 'package:greengrocer/src/pages/auth/repository/auth_repository.dart';
import 'package:greengrocer/src/pages/auth/result/auth_result.dart';
import 'package:greengrocer/src/pages_routes/app_routes.dart';
import 'package:greengrocer/src/services/utils_services.dart';

class AuthController extends GetxController {
  RxBool isLoading = false.obs;

  final authRepository = AuthRepository();
  final utilsServices = UtilsServices();

  UserModel user = UserModel();

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    AuthResult result = await authRepository.signIn(
      email: email,
      password: password,
    );
    isLoading.value = false;
    result.when(
      success: (user) async {
        this.user = user;
        await saveTokenAndProceedToBase();
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }

  Future<void> validateToken() async {
    String? token = await utilsServices.getLocalData(
      key: StorageKeys.token,
    );
    if (token == null) {
      Get.offAllNamed(
        AppRoutes.signInRoute,
      );
      return;
    }

    final result = await authRepository.validateToken(
      token: token,
    );

    result.when(
      success: (user) async {
        this.user = user;
        await saveTokenAndProceedToBase();
      },
      error: (message) async {
        await signOut();
      },
    );
  }

  Future<void> saveTokenAndProceedToBase() async {
    await utilsServices.saveLocalData(
      key: StorageKeys.token,
      data: user.token!,
    );
    Get.offAllNamed(AppRoutes.baseRoute);
  }

  Future<void> signOut() async {
    user = UserModel();
    await utilsServices.removeLocalData(
      key: StorageKeys.token,
    );
    Get.offAllNamed(
      AppRoutes.signInRoute,
    );
  }

  Future<void> signUp() async {
    isLoading.value = true;
    final result = await authRepository.signUp(user);
    isLoading.value = false;
    result.when(
      success: (user) {
        this.user = user;
        saveTokenAndProceedToBase();
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }

  Future<void> resetPassword(String email) async {
    await authRepository.resetPassword(email);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    isLoading.value = true;
    final result = await authRepository.changePassword(
      token: user.token!,
      email: user.email!,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    isLoading.value = false;
    if (result) {
      utilsServices.showToast(
        message: 'A senha foi atualizada com sucesso',
      );
      signOut();
    } else {
      utilsServices.showToast(
        message: 'A senha atual está incorreta',
        isError: true,
      );
    }
  }
}
