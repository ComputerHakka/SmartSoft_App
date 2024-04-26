import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smartsoft_application/models/product.dart';
import 'package:smartsoft_application/models/status.dart';
import 'package:smartsoft_application/widgets/custom_appbar.dart';
import 'package:smartsoft_application/widgets/order_product_card_widget.dart';

import '../blocs/productBloc/bloc/product_bloc.dart';
import '../blocs/statusBloc/bloc/status_bloc.dart';
import '../models/order.dart';

class SelectedOrderPage extends StatelessWidget {
  final OrderModel order;
  const SelectedOrderPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    var productState = context.read<ProductBloc>().state;
    var statusState = context.read<StatusBloc>().state;
    Map<Product, int>? currentProducts = {};
    Status? currentStatus;
    if (productState is ProductLoadedState) {
      for (Product product in productState.products) {
        for (var productOrder in order.productsFromBase!.entries) {
          if (product.id == productOrder.key) {
            currentProducts[product] = productOrder.value;
          }
        }
      }
    }
    if (statusState is StatusLoadedState) {
      currentStatus = statusState.statuses
          .firstWhere((status) => status.id == order.statusId);
    }

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Заказ',
        searchActivate: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Заказ #${order.id}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            order.statusId == 'Y01JSaUYbShJE1K22cP9' ||
                    order.statusId == 'yH44aI3nAhL7qWnC7Rha'
                ? Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        const Icon(
                          Icons.local_shipping_rounded,
                          size: 80,
                          color: Colors.amber,
                        ),
                        Text(
                          currentStatus!.name,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : order.statusId == '5ysB07cxIx3B6Qjw0HIR' ||
                        order.statusId == 'ClxFUQNHzrzhDlQljg88'
                    ? Container(
                        width: double.infinity,
                        child: Column(
                          children: [
                            const Icon(
                              Icons.archive,
                              size: 80,
                              color: Colors.blue,
                            ),
                            Text(
                              currentStatus!.name,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        child: Column(
                          children: [
                            const Icon(
                              Icons.check_circle_outline_outlined,
                              size: 80,
                              color: Colors.green,
                            ),
                            Text(
                              currentStatus!.name,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
            const SizedBox(height: 8),
            order.statusId != 'F0yITXjBtxMOQfLL0eOS'
                ? Column(
                    children: [
                      const Text(
                        'Покажите данный штрих-код для получения заказа:',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 70,
                        width: double.infinity,
                        margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: BarcodeWidget(
                          data: order.id!,
                          barcode: Barcode.code128(),
                          drawText: false,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  )
                : const SizedBox(
                    height: 0,
                  ),
            Text(
              'Дата заказа: ${DateFormat('dd.MM.yyyy').format(order.date!)}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Оплата: ',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: order.isPaid! ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    order.isPaid! ? 'Оплачен' : 'Не оплачен',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Общая стоимость: ${order.totalPrice!.toStringAsFixed(2)} Руб.',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Товары:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: currentProducts.length,
                itemBuilder: (context, index) {
                  List<Product> indexProduct = currentProducts.keys.toList();
                  List<int> indexQuantity = currentProducts.values.toList();
                  return Container(
                    margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: OrderProductCard(
                        product: indexProduct[index],
                        quantity: indexQuantity[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
