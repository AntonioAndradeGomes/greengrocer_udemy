import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/models/cart_item_model.dart';
import 'package:greengrocer/src/models/order_model.dart';
import 'package:greengrocer/src/pages/common_widgets/payment_dialog.dart';
import 'package:greengrocer/src/pages/orders/controller/order_controller.dart';
import 'package:greengrocer/src/pages/orders/view/components/order_status_widget.dart';
import 'package:greengrocer/src/services/utils_services.dart';

class OrderTile extends StatelessWidget {
  final OrderModel order;
  final utilsServices = UtilsServices();
  OrderTile({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: GetBuilder<OrderController>(
            init: OrderController(
              order: order,
            ),
            global: false,
            builder: (controller) {
              return ExpansionTile(
                //initiallyExpanded: order.status == 'pending_payment',
                onExpansionChanged: (value) {
                  if (value && order.items.isEmpty) {
                    controller.getOrderItem();
                  }
                },
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pedido: ${order.id}',
                    ),
                    Text(
                      utilsServices.formatDateTime(order.createdDateTime!),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                children: controller.isLoading
                    ? [
                        Container(
                          height: 80,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        ),
                      ]
                    : [
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: SizedBox(
                                  height: 150,
                                  child: ListView(
                                    children: order.items
                                        .map(
                                          (orderItem) => _OrderItemWidget(
                                            utilsServices: utilsServices,
                                            item: orderItem,
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ),
                              VerticalDivider(
                                color: Colors.grey.shade300,
                                thickness: 2,
                                width: 8,
                              ),
                              Expanded(
                                flex: 2,
                                child: OrderStatusWidget(
                                  isOverdue: order.overdueDateTime
                                      .isBefore(DateTime.now()),
                                  status: order.status,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                            children: [
                              const TextSpan(
                                text: 'Total ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: utilsServices.priceCurrency(order.total),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: order.status == 'pending_payment' &&
                              !order.isOverDue,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => PaymentDialog(
                                  order: order,
                                ),
                              );
                            },
                            icon: Image.asset(
                              'assets/app_images/pix.png',
                              height: 18,
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            label: const Text(
                              'Ver QR Code Pix',
                            ),
                          ),
                        ),
                      ],
              );
            },
          )),
    );
  }
}

class _OrderItemWidget extends StatelessWidget {
  const _OrderItemWidget({
    Key? key,
    required this.utilsServices,
    required this.item,
  }) : super(key: key);

  final UtilsServices utilsServices;
  final CartItemModel item;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Row(
        children: [
          Text(
            '${item.quantity}${item.item.unit} ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              item.item.itemName,
            ),
          ),
          Text(
            utilsServices.priceCurrency(item.totalPrice),
          ),
        ],
      ),
    );
  }
}
