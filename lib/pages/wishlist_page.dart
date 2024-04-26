import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smartsoft_application/blocs/wishlistBloc/bloc/wishlist_bloc.dart';

import '../widgets/custom_appbar.dart';
import '../widgets/product_cell_widget.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Избранное',
        searchActivate: false,
      ),
      body: Center(
        child: BlocBuilder<WishlistBloc, WishlistState>(
          builder: (context, state) {
            if (state is WishlistLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is WishlistLoadedState) {
              if (state.wishlist.products!.isNotEmpty) {
                return SafeArea(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      itemCount: state.wishlist.products!.length,
                      itemBuilder: (context, index) {
                        return ProductCellWidget(
                          product: state.wishlist.products![index],
                          inWishlist: true,
                        );
                      },
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Пусто :(',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\nДобавьте свой первый товар\nв избранное, нажав на сердечко\nв ячейке товара',
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
              }
            }
            if (state is WishlistErrorState) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Не избран :|',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\nДля того, чтобы добавлять\nтовары в избранное, необходимо\nавторизироваться в системе',
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
              return const Center(
                child: Text('Упс...Что-то пошло не так'),
              );
            }
          },
        ),
      ),
    );
  }
}
