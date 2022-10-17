import 'package:get/get.dart';
import 'package:greengrocer/src/models/cart_item_model.dart';
import 'package:greengrocer/src/pages/auth/controllers/auth_controller.dart';
import 'package:greengrocer/src/pages/cart/repository/cart_repository.dart';
import 'package:greengrocer/src/services/utils_services.dart';

class CartController extends GetxController {
  final _cartRepository = CartRepository();
  final _authController = Get.find<AuthController>();
  final _utilsSerices = UtilsServices();

  List<CartItemModel> cartItems = [];

  @override
  void onInit() {
    super.onInit();
    getCartItems();
  }

  double cartTotalPrice() {
    double total = 0;
    for (final item in cartItems) {
      total += item.totalPrice;
    }
    return total;
  }

  Future<void> getCartItems() async {
    final result = await _cartRepository.getCartItems(
      token: _authController.user.token!,
      userId: _authController.user.id!,
    );

    result.when(
      success: (data) {
        cartItems = data;
        update();
      },
      error: (message) {
        _utilsSerices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }
}
