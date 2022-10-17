import 'package:greengrocer/src/models/item_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'cart_item_model.g.dart';

@JsonSerializable()
class CartItemModel {
  String id;

  @JsonKey(
    name: 'product',
  )
  ItemModel item;

  int quantity;

  CartItemModel({
    required this.id,
    required this.item,
    required this.quantity,
  });

  double get totalPrice => item.price * quantity;

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);

  @override
  String toString() =>
      'CartItemModel(item: $item, id: $id, quantity: $quantity)';
}
