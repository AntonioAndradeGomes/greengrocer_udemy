import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/config/custom_colors.dart';
import 'package:greengrocer/src/models/item_model.dart';
import 'package:greengrocer/src/pages/cart/controller/cart_controller.dart';
import 'package:greengrocer/src/pages_routes/app_routes.dart';
import 'package:greengrocer/src/services/utils_services.dart';

class ItemTile extends StatefulWidget {
  final ItemModel itemModel;
  final void Function(GlobalKey) cardAnimationMethod;

  const ItemTile({
    Key? key,
    required this.itemModel,
    required this.cardAnimationMethod,
  }) : super(key: key);

  @override
  State<ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  final GlobalKey imageGK = GlobalKey();

  final utilsServices = UtilsServices();

  final _cartController = Get.find<CartController>();

  IconData tileIcon = Icons.add_shopping_cart_outlined;

  Future<void> switchIcon() async {
    setState(
      () => tileIcon = Icons.check,
    );
    await Future.delayed(
      const Duration(
        milliseconds: 1500,
      ),
    );
    setState(
      () => tileIcon = Icons.add_shopping_cart_outlined,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Get.toNamed(
              AppRoutes.productRoute,
              arguments: widget.itemModel,
            );
          },
          child: Card(
            elevation: 1,
            shadowColor: Colors.grey.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Hero(
                      tag: widget.itemModel.imgUrl,
                      child: Image.network(
                        widget.itemModel.imgUrl,
                        key: imageGK,
                      ),
                    ),
                  ),
                  Text(
                    widget.itemModel.itemName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        utilsServices.priceCurrency(
                          widget.itemModel.price,
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: CustomColors.customSwatchColor,
                        ),
                      ),
                      Text(
                        '/${widget.itemModel.unit}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(15),
              topRight: Radius.circular(20),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  switchIcon();
                  _cartController.addItemToCart(
                    item: widget.itemModel,
                  );
                  widget.cardAnimationMethod(imageGK);
                },
                child: Ink(
                  height: 40,
                  width: 35,
                  decoration: BoxDecoration(
                    color: CustomColors.customSwatchColor,
                  ),
                  child: Icon(
                    tileIcon,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
