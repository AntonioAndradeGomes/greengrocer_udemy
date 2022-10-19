import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/models/cart_item_model.dart';
import 'package:greengrocer/src/models/item_model.dart';
import 'package:greengrocer/src/models/order_model.dart';
import 'package:greengrocer/src/pages/auth/controllers/auth_controller.dart';
import 'package:greengrocer/src/pages/cart/repository/cart_repository.dart';
import 'package:greengrocer/src/pages/cart/result/cart_result.dart';
import 'package:greengrocer/src/pages/common_widgets/payment_dialog.dart';
import 'package:greengrocer/src/services/utils_services.dart';

class CartController extends GetxController {
  final _cartRepository = CartRepository();
  final _authController = Get.find<AuthController>();
  final _utilsSerices = UtilsServices();

  List<CartItemModel> cartItems = [];

  bool isCheckoutLoading = false;

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

  int _getItemIndex(ItemModel item) {
    return cartItems.indexWhere((element) => element.item.id == item.id);
  }

  Future<void> addItemToCart({
    required ItemModel item,
    int quantity = 1,
  }) async {
    int itemIndex = _getItemIndex(item);
    if (itemIndex >= 0) {
      //existe item na listagem
      //recuperar item na listam e adicionar a quantidade
      final product = cartItems[itemIndex];
      await changeItemQuantity(
        itemModel: product,
        quantity: (product.quantity + quantity),
      );
    } else {
      //não existe
      final cartResult = await _cartRepository.addItemToCart(
        userId: _authController.user.id!,
        token: _authController.user.token!,
        productId: item.id,
        quantity: quantity,
      );
      cartResult.when(
        success: (cartItemId) {
          cartItems.add(
            CartItemModel(
              id: cartItemId,
              item: item,
              quantity: quantity,
            ),
          );
        },
        error: (message) {
          _utilsSerices.showToast(
            message: message,
            isError: true,
          );
        },
      );
    }
    update();
  }

  Future<bool> changeItemQuantity({
    required CartItemModel itemModel,
    required int quantity,
  }) async {
    final result = await _cartRepository.changeItemQuantity(
      token: _authController.user.token!,
      cartItemId: itemModel.id,
      quantity: quantity,
    );

    if (result) {
      if (quantity == 0) {
        cartItems.removeWhere((element) => element.id == itemModel.id);
      } else {
        cartItems.firstWhere((element) => element.id == itemModel.id).quantity =
            quantity;
      }
      update();
    } else {
      _utilsSerices.showToast(
        message: 'Ocorreu um erro ao alterar a quantidade do produto',
        isError: true,
      );
    }

    return result;
  }

  //retornando a quantidade de itens de forma unitária
  int getCartTotalItems() {
    return cartItems.isEmpty
        ? 0
        : cartItems
            .map(
              (e) => e.quantity,
            )
            .reduce(
              (value, element) => value + element,
            );
  }

  void setCheckoutLoading(bool value) {
    isCheckoutLoading = value;
    update();
  }

  Future<void> checkoutCart() async {
    setCheckoutLoading(true);
    final result = await _cartRepository.checkoutCart(
      token: _authController.user.token!,
      total: cartTotalPrice(),
    );
    setCheckoutLoading(false);
    result.when(
      success: (order) {
        cartItems.clear();
        update();
        showDialog(
          context: Get.context!,
          builder: (_) => PaymentDialog(
            order: order,
          ),
        );
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
