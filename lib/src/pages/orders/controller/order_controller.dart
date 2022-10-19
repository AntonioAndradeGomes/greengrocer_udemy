import 'package:get/get.dart';
import 'package:greengrocer/src/config/app_data.dart';
import 'package:greengrocer/src/models/order_model.dart';
import 'package:greengrocer/src/pages/auth/controllers/auth_controller.dart';
import 'package:greengrocer/src/pages/orders/repository/orders_repository.dart';
import 'package:greengrocer/src/services/utils_services.dart';

class OrderController extends GetxController {
  final _repository = OrdersRepository();
  final _authController = Get.find<AuthController>();
  final _utilsServices = UtilsServices();
  bool isLoading = false;

  final OrderModel order;

  OrderController({
    required this.order,
  });

  void setLoading(bool value) {
    isLoading = value;
    update();
  }

  Future<void> getOrderItem() async {
    setLoading(true);
    final result = await _repository.getOrderItems(
      orderId: order.id,
      token: _authController.user.token!,
    );
    setLoading(false);
    result.when(
      success: (data) {
        order.items = data;
        update();
      },
      error: (message) {
        _utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }
}
