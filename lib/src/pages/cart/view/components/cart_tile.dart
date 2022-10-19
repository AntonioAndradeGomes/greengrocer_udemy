import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/config/custom_colors.dart';
import 'package:greengrocer/src/models/cart_item_model.dart';
import 'package:greengrocer/src/pages/cart/controller/cart_controller.dart';
import 'package:greengrocer/src/pages/common_widgets/quantity_widget.dart';
import 'package:greengrocer/src/services/utils_services.dart';

class CartTile extends StatelessWidget {
  final CartItemModel item;
  // final Function(CartItemModel cartItem) remove;
  CartTile({
    Key? key,
    required this.item,
    // required this.remove,
  }) : super(key: key);

  final _utilsService = UtilsServices();
  final _controller = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Image.network(
          item.item.imgUrl,
          height: 50,
          width: 60,
        ),
        title: Text(
          item.item.itemName,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          _utilsService.priceCurrency(
            item.totalPrice,
          ),
          style: TextStyle(
            color: CustomColors.customSwatchColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: QuantityWidget(
          value: item.quantity,
          suffixText: item.item.unit,
          result: (quantity) {
            _controller.changeItemQuantity(
              itemModel: item,
              quantity: quantity,
            );
          },
          isRemovable: true,
        ),
      ),
    );
  }
}
