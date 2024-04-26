import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsoft_application/theme/app_theme.dart';
import 'package:smartsoft_application/utils/discount_calculator.dart';

import '../blocs/cartBloc/bloc/cart_bloc.dart';
import '../models/user.dart';

class OrderSummary extends StatelessWidget {
  final UserModel user;
  const OrderSummary({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoadedState) {
          double total = state.cart.totalString.toDouble();
          double discount = 0.0;

          discount = DiscountCalculator()
              .calculateDiscount(user.level, total)
              .roundToDouble();
          double discountedTotal = total - discount;
          return Column(
            children: [
              const SizedBox(height: 10),
              Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 105,
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                        color: Colors.black.withAlpha(50),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5.0),
                    width: MediaQuery.of(context).size.width - 10,
                    height: 95,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Сумма заказа: ',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              Text(
                                '${state.cart.totalString.toStringAsFixed(2)} руб',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Скидка: ',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              Text(
                                '${discount.round().toStringAsFixed(2)} руб',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                            child: Divider(
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Итого к оплате: ',
                                style: TextStyle(
                                    color: kAccentColor, fontSize: 16),
                              ),
                              Text(
                                '${discountedTotal.round().toStringAsFixed(2)} руб',
                                style: TextStyle(
                                    color: kAccentColor, fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          return const Text('Упс...Что-то пошло не так');
        }
      },
    );
  }
}
