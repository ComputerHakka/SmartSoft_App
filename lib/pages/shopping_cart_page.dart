import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsoft_application/models/user.dart';
import 'package:smartsoft_application/widgets/custom_appbar.dart';
import 'package:smartsoft_application/widgets/product_cell_widget.dart';

import '../blocs/authBloc/bloc/authorization_bloc.dart';
import '../blocs/cartBloc/bloc/cart_bloc.dart';
import '../widgets/cart_product_card_widget.dart';
import '../widgets/order_summary.dart';
import 'order_page.dart';

class ShoppingCartPage extends StatelessWidget {
  const ShoppingCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(title: 'Корзина'),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }
          if (state is CartLoadedState) {
            UserModel currentUser = UserModel.empty;
            var currentUserState = context.read<AuthorizationBloc>().state;
            if (currentUserState.status ==
                AuthorizationStatus.unauthenticated) {
              currentUser = UserModel.empty;
            } else {
              currentUser = currentUserState.user!;
            }
            Map cart = state.cart.productQuantity(state.cart.products);

            if (cart.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Корзина пустует :(((',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\nЕсли хотите что-то купить,\nперейдите в каталог и выберите\nнеобходимые товары',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 380,
                      child: ListView.builder(
                        itemCount: cart.keys.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CartProductCard(
                            product: cart.keys.elementAt(index),
                            quantity: cart.values.elementAt(index),
                          );
                        },
                      ),
                    ),
                    OrderSummary(
                      user: currentUser,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrderPage(),
                          ),
                        );
                      },
                      child: const Text('К оформлению'),
                    )
                  ],
                ),
              );
            }
          }
          return const Text('Упс...Что-то пошло не так');
        },
      ),
    );
  }
}
