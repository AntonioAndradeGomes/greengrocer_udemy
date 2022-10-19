import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/config/app_data.dart' as appData;
import 'package:greengrocer/src/config/custom_colors.dart';
import 'package:greengrocer/src/pages/cart/controller/cart_controller.dart';
import 'package:greengrocer/src/pages/cart/view/components/cart_tile.dart';
import 'package:greengrocer/src/pages/common_widgets/payment_dialog.dart';
import 'package:greengrocer/src/services/utils_services.dart';

class CartTab extends StatefulWidget {
  const CartTab({Key? key}) : super(key: key);

  @override
  State<CartTab> createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  final _utilsService = UtilsServices();
  final _cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Carrinho',
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GetBuilder<CartController>(
              builder: (controller) {
                if (controller.cartItems.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.remove_shopping_cart,
                        color: CustomColors.customSwatchColor,
                        size: 60,
                      ),
                      const Text(
                        'Não há itens no carrinho',
                      ),
                    ],
                  );
                }
                return ListView.builder(
                  itemCount: controller.cartItems.length,
                  itemBuilder: (_, index) => CartTile(
                    item: controller.cartItems[index],
                    //remove: removeItemFromCart,
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 3,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Total geral',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                GetBuilder<CartController>(
                  builder: (controller) {
                    return Text(
                      _utilsService.priceCurrency(
                        controller.cartTotalPrice(),
                      ),
                      style: TextStyle(
                        fontSize: 25,
                        color: CustomColors.customSwatchColor,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                GetBuilder<CartController>(
                  builder: (controller) {
                    return SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: CustomColors.customSwatchColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: controller.isCheckoutLoading
                            ? null
                            : () async {
                                bool? result = await showOrderConfirmation();
                                if (result ?? false) {
                                  _cartController.checkoutCart();
                                } else {
                                  _utilsService.showToast(
                                    message: 'Pedido não confirmado',
                                  );
                                }
                              },
                        child: controller.isCheckoutLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                                'Concluir pedido',
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<bool?> showOrderConfirmation() async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Confirmação',
          ),
          content: const Text(
            'Deseja realmente concluir o pedido?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(
                'Não',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Sim',
              ),
            ),
          ],
        );
      },
    );
  }
}
