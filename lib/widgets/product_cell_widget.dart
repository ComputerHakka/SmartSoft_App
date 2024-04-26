import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smartsoft_application/models/product.dart';
import 'package:smartsoft_application/pages/product_page.dart';

import '../blocs/cartBloc/bloc/cart_bloc.dart';
import '../blocs/comparisonBloc/bloc/comparison_bloc.dart';
import '../blocs/wishlistBloc/bloc/wishlist_bloc.dart';

class ProductCellWidget extends StatelessWidget {
  final bool inWishlist;
  final Product product;
  const ProductCellWidget(
      {super.key, required this.product, required this.inWishlist});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        child: Container(
          width: MediaQuery.of(context).size.width / 2 - 5,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Stack(children: [
                    Image.network(
                      product.imgUrl,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: BlocBuilder<WishlistBloc, WishlistState>(
                        builder: (context, state) {
                          if (state is WishlistLoadingState) {
                            return Container();
                          }
                          if (state is WishlistLoadedState) {
                            var wishlistProduct = state.wishlist.productsIDs!
                                .where((productId) =>
                                    productId.contains(product.id))
                                .toList();
                            return IconButton(
                              onPressed: () {
                                if (wishlistProduct.isEmpty) {
                                  context.read<WishlistBloc>().add(
                                        AddProductToWishlistEvent(
                                            product: product,
                                            wishlist: state.wishlist),
                                      );
                                } else {
                                  context.read<WishlistBloc>().add(
                                        RemoveProductToWishlistEvent(
                                            product: product,
                                            wishlist: state.wishlist),
                                      );
                                }
                              },
                              icon: wishlistProduct.isEmpty
                                  ? Icon(
                                      Icons.favorite_border,
                                      color: HexColor('1E1E1E'),
                                      size: 30,
                                    )
                                  : Icon(
                                      Icons.favorite,
                                      color: HexColor('DC143C'),
                                      size: 30,
                                    ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  product.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text('${product.price.toStringAsFixed(2)} Руб.',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black54)),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocBuilder<CartBloc, CartState>(
                      builder: (context, state) {
                        if (state is CartLoadingState) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is CartLoadedState) {
                          return ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  elevation: 5,
                                  margin: EdgeInsets.fromLTRB(50, 0, 50, 30),
                                  content: Text(
                                    'Товар добавлен в корзину',
                                    textAlign: TextAlign.center,
                                  ),
                                  duration: Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              context
                                  .read<CartBloc>()
                                  .add(AddProductEvent(product));
                            },
                            child: const Center(
                              child: Text('В корзину'),
                            ),
                          );
                        } else {
                          return const Center(
                            child: Text('Упс...Что-то пошло не так'),
                          );
                        }
                      },
                    ),
                    BlocBuilder<ComparisonBloc, ComparisonState>(
                      builder: (context, state) {
                        if (state is ComparisonLoadedState) {
                          var currentProductInComparison = state
                              .comparison.products
                              .where((p) => p.id == product.id)
                              .toList();
                          return IconButton(
                            onPressed: () {
                              if (currentProductInComparison.isEmpty) {
                                context.read<ComparisonBloc>().add(
                                      AddProductToComparisonEvent(product),
                                    );
                              } else {
                                context.read<ComparisonBloc>().add(
                                      RemoveProductFromComparisonEvent(product),
                                    );
                              }
                            },
                            icon: currentProductInComparison.isEmpty
                                ? Icon(
                                    Icons.compare_rounded,
                                    color: HexColor('1E1E1E'),
                                    size: 30,
                                  )
                                : Icon(
                                    Icons.compare_rounded,
                                    color: HexColor('34CF45'),
                                    size: 30,
                                  ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(
              product: product,
            ),
          ),
        );
      },
    );
  }
}
