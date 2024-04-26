import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsoft_application/widgets/custom_appbar.dart';

import '../blocs/orderBloc/getOrders/get_orders_bloc.dart';
import '../models/user.dart';
import '../widgets/order_card_widget.dart';

class MyOrdersPage extends StatelessWidget {
  final UserModel user;
  const MyOrdersPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Мои заказы',
        searchActivate: false,
      ),
      body: Container(
        margin: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<GetOrdersBloc, GetOrdersState>(
              builder: (context, state) {
                if (state is GetOrderLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is GetOrderLoadedState) {
                  if (state.orders.isNotEmpty) {
                    state.orders.sort((a, b) => a.date!
                        .difference(DateTime.now())
                        .abs()
                        .compareTo(b.date!.difference(DateTime.now()).abs()));
                    return Container(
                      margin: const EdgeInsets.all(5),
                      height: MediaQuery.of(context).size.height - 140,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: state.orders.length,
                        itemBuilder: (BuildContext context, int index) {
                          return OrderCard(order: state.orders[index]);
                        },
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text(
                        'Вы ещё не сделали ни одного заказа',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                }
                if (state is GetOrderEmptyState) {
                  return const Center(
                    child: Text(
                      'Вы ещё не сделали ни одного заказа',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text('Упс...Что-то пошло не так'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
