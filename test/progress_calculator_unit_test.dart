import 'package:flutter_test/flutter_test.dart';
import 'package:smartsoft_application/models/order.dart';
import 'package:smartsoft_application/utils/bonus_program_calculator.dart';

void main() {
  test('calculateProgress_PositiveTest', () {
    int initialTotal = 20000;
    int initialLevel = 1;
    double result =
        BonusProgramCalculator().calculateProgress(initialTotal, initialLevel);
    expect(result, 0.5);
  });

  test('calculateProgress_NegativeTest', () {
    int initialTotal = 50000;
    int initialLevel = 4;
    double result =
        BonusProgramCalculator().calculateProgress(initialTotal, initialLevel);
    expect(result, equals(0.25));
  });
  test('calculateTotal_PositiveTest', () {
    List<OrderModel> orders = [
      const OrderModel(
          id: '123',
          isPaid: true,
          totalPrice: 5000), // Оплаченный заказ с ценой 5000
      const OrderModel(
          id: '456',
          isPaid: true,
          totalPrice: 8000), // Оплаченный заказ с ценой 8000
      const OrderModel(
          id: '789',
          isPaid: true,
          totalPrice: 10000), // Оплаченный заказ с ценой 10000
    ];

    int total = BonusProgramCalculator().calculateTotal(orders);

    expect(total, equals(23000));
  });

  test('calculateTotal_NegativeTest', () {
    List<OrderModel> orders = [
      const OrderModel(
          id: '123',
          isPaid: true,
          totalPrice: 5000), // Оплаченный заказ с ценой 5000
      const OrderModel(
          id: '456',
          isPaid: false,
          totalPrice: 8000), // Неоплаченный заказ с ценой 8000
      const OrderModel(
          id: '789',
          isPaid: true,
          totalPrice: 10000), // Оплаченный заказ с ценой 10000
    ];

    BonusProgramCalculator calculator = BonusProgramCalculator();
    int total = calculator.calculateTotal(orders);

    expect(
        total,
        equals(
            15000)); // Ожидаемый результат: только оплаченные заказы учитываются, поэтому сумма равна 15000 (5000 + 10000)
  });
}
