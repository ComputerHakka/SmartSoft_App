import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:smartsoft_application/theme/app_theme.dart';
import 'package:smartsoft_application/utils/bonus_program_calculator.dart';
import 'package:smartsoft_application/widgets/custom_appbar.dart';

import '../blocs/orderBloc/getOrders/get_orders_bloc.dart';
import '../blocs/profileBloc/bloc/profile_bloc.dart';
import '../models/user.dart';

class LevelPage extends StatelessWidget {
  final UserModel currentUser;
  final BuildContext currentContext;
  final List<String> levelDescriptions = [
    'Бронза (Уровень 1)',
    'Серебро (Уровень 2)',
    'Золото (Уровень 3)',
    'Алмаз (Уровень 4)',
    'Мастер цифровых технологий (Уровень 5)',
  ];
  final List<String> privilege = [
    'Стандартный уровень пользователя',
    'Скидка на товары магазина 2%',
    'Скидка на товары магазина 5%',
    'Скидка на товары магазина 8%',
    'Скидка на товары магазина 15%',
  ];
  final List<int> levelPrice = [
    40000,
    80000,
    150000,
    200000,
    400000,
  ];
  LevelPage(
      {super.key, required this.currentUser, required this.currentContext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Уровень',
        searchActivate: false,
      ),
      body: BlocBuilder<GetOrdersBloc, GetOrdersState>(
        builder: (context, state) {
          if (state is GetOrderLoadedState) {
            int total = BonusProgramCalculator().calculateTotal(state.orders);
            double progress = BonusProgramCalculator()
                .calculateProgress(total, currentUser.level);
            int currentLevel = currentUser.level;
            if (progress >= 1) {
              progress = BonusProgramCalculator()
                  .calculateProgress(total, currentUser.level + 1);
              currentLevel += 1;
              currentContext.read<ProfileBloc>().add(EditUserEvent(
                  currentUser.copyWith(level: currentUser.level + 1)));
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CircularPercentIndicator(
                    radius: 45.0,
                    lineWidth: 8.0,
                    animation: true,
                    circularStrokeCap: CircularStrokeCap.round,
                    percent: progress,
                    center: Text(
                      '${currentLevel}',
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    progressColor: Colors.orange,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Куплено товаров на сумму\n${total.toStringAsFixed(2)} Руб. из ${levelPrice[currentLevel - 1].toStringAsFixed(2)} Руб.',
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'До повышения уровня: ',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        ' ${(levelPrice[currentLevel - 1] - total).toStringAsFixed(2)} Руб.',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: kAccentColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  const Text(
                    'Привилегии:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: levelDescriptions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Icon(
                            index < currentLevel
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: index < currentLevel
                                ? Colors.green
                                : Colors.grey,
                          ),
                          title: Text(levelDescriptions[index]),
                          subtitle: Text(privilege[index]),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24.0),
                ],
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
