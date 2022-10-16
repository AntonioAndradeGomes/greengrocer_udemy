import 'package:greengrocer/src/models/item_model.dart';

class CartItemModel {
  final ItemModel item;
  int quantity;

  CartItemModel({
    required this.item,
    required this.quantity,
  });

  double get totalPrice => item.price * quantity;
}
