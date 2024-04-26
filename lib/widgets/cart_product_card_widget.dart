import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smartsoft_application/models/product.dart';

import '../blocs/cartBloc/bloc/cart_bloc.dart';

class CartProductCard extends StatelessWidget {
  final Product product;
  final int quantity;
  const CartProductCard(
      {super.key, required this.product, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Row(
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
              Text('${product.price.toStringAsFixed(2)} Руб.'),
            ],
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            return Row(
              children: [
                IconButton(
                  onPressed: () {
                    context.read<CartBloc>().add(RemoveProductEvent(product));
                  },
                  icon: Icon(
                    Icons.remove_circle,
                    color: HexColor('1E1E1E'),
                  ),
                ),
                Text('$quantity'),
                IconButton(
                  onPressed: () {
                    context.read<CartBloc>().add(AddProductEvent(product));
                  },
                  icon: Icon(
                    Icons.add_circle,
                    color: HexColor('1E1E1E'),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
