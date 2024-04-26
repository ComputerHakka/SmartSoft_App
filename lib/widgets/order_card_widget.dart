import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsoft_application/models/order.dart';
import 'package:intl/intl.dart';
import 'package:smartsoft_application/models/product.dart';
import '../blocs/productBloc/bloc/product_bloc.dart';
import '../blocs/statusBloc/bloc/status_bloc.dart';
import '../pages/selected_order_page.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectedOrderPage(
              order: order,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 4.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Заказ\n#${order.id}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Дата: ${DateFormat('dd.MM.yyyy').format(order.date!)}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Стоимость: ${order.totalPrice!.toStringAsFixed(2)} Руб.',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16.0),
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is ProductLoadedState) {
                  List<Product> currentProducts = [];
                  for (Product product in state.products) {
                    for (String productId in order.productsFromBase!.keys) {
                      if (product.id == productId) {
                        currentProducts.add(product);
                      }
                    }
                  }
                  return Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 15, 0),
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: currentProducts.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              currentProducts[index].imgUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: Text('Данные не доступны'),
                  );
                }
              },
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
              child: BlocBuilder<StatusBloc, StatusState>(
                builder: (context, state) {
                  if (state is StatusLoadingState) {
                    return Container();
                  }
                  if (state is StatusLoadedState) {
                    var currentStatus = state.statuses
                        .firstWhere((status) => status.id == order.statusId);
                    if (currentStatus != null) {
                      return Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              currentStatus.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
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
                      );
                    } else {
                      return const Center(
                        child: Text('Данные не доступны'),
                      );
                    }
                  } else {
                    return const Center(
                      child: Text('Данные не доступны'),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
