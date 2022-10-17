import 'package:flutter/material.dart';
import 'package:greengrocer/src/config/custom_colors.dart';
import 'package:greengrocer/src/models/cart_item_model.dart';
import 'package:greengrocer/src/pages/common_widgets/quantity_widget.dart';
import 'package:greengrocer/src/services/utils_services.dart';

class CartTile extends StatefulWidget {
  final CartItemModel item;
  final Function(CartItemModel cartItem) remove;
  const CartTile({
    Key? key,
    required this.item,
    required this.remove,
  }) : super(key: key);

  @override
  State<CartTile> createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  final utilsService = UtilsServices();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Image.asset(
          widget.item.item.imgUrl,
          height: 50,
          width: 60,
        ),
        title: Text(
          widget.item.item.itemName,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          utilsService.priceCurrency(widget.item.totalPrice),
          style: TextStyle(
            color: CustomColors.customSwatchColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: QuantityWidget(
          value: widget.item.quantity,
          suffixText: widget.item.item.unit,
          result: (quantity) {
            setState(() {
              widget.item.quantity = quantity;
              if (quantity == 0) {
                widget.remove(widget.item);
              }
            });
          },
          isRemovable: true,
        ),
      ),
    );
  }
}
