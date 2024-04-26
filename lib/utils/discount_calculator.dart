class DiscountCalculator {
  double calculateDiscount(int level, double total) {
    double discount = 0.0;

    if (level == 2) {
      discount = total * 0.02;
    } else if (level == 3) {
      discount = total * 0.05;
    } else if (level == 4) {
      discount = total * 0.08;
    } else if (level == 5) {
      discount = total * 0.15;
    }

    return discount;
  }
}
