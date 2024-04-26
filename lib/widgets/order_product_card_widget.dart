import 'package:flutter/material.dart';
import 'package:smartsoft_application/pages/product_page.dart';

import '../models/product.dart';

class OrderProductCard extends StatelessWidget {
  final Product product;
  final int quantity;
  const OrderProductCard(
      {super.key, required this.product, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(product: product),
          ),
        );
      },
      child: Row(
        children: [
          Image.network(
            product.imgUrl,
            width: 100,
            height: 80,
          ),
          const SizedBox(
            width: 5.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text('${product.price.toStringAsFixed(2)} Руб.'),
              ],
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          SizedBox(width: 60, child: Center(child: Text('$quantity шт.'))),
        ],
      ),
    );
  }
}
