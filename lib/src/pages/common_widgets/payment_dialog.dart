import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:greengrocer/src/models/order_model.dart';
import 'package:greengrocer/src/services/utils_services.dart';

class PaymentDialog extends StatelessWidget {
  final OrderModel order;
  final utilsServices = UtilsServices();
  PaymentDialog({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Text(
                    'Pagamento com Pix',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Image.memory(
                  utilsServices.decodeQrCodeImage(
                    order.qrCodeImage,
                  ),
                  height: 200,
                  width: 200,
                ),
                Text(
                  'Vencimento: ${utilsServices.formatDateTime(order.overdueDateTime)}',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                Text(
                  'Total: ${utilsServices.priceCurrency(order.total)}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: const BorderSide(
                      width: 2,
                      color: Colors.green,
                    ),
                  ),
                  onPressed: () {
                    FlutterClipboard.copy(order.copyAndPaste);
                    utilsServices.showToast(
                      message: 'Código Pix copiado',
                    );
                  },
                  icon: const Icon(
                    Icons.copy,
                    size: 15,
                  ),
                  label: const Text(
                    'Copiar código Pix',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              splashRadius: 18,
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.close,
              ),
            ),
          )
        ],
      ),
    );
  }
}
