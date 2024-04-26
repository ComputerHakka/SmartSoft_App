import '../models/order.dart';

class BonusProgramCalculator {
  int calculateTotal(List<OrderModel> orders) {
    int total = 0;
    for (var order in orders) {
      if (order.isPaid!) {
        total += order.totalPrice!;
      }
    }
    return total;
  }

  double calculateProgress(int total, int level) {
    double progress = 0.0;
    switch (level) {
      case 1:
        progress = total / 40000;
        break;
      case 2:
        progress = total / 80000;
        break;
      case 3:
        progress = total / 150000;
        break;
      case 4:
        progress = total / 200000;
        break;
      case 5:
        progress = total / 400000;
        break;
    }
    return progress;
  }
}
