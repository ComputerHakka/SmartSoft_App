import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smartsoft_application/models/product.dart';
import 'package:smartsoft_application/widgets/product_cell_widget.dart';

import '../blocs/productBloc/bloc/product_bloc.dart';
import '../models/category.dart';
import '../widgets/custom_appbar.dart';

class CategoryPage extends StatelessWidget {
  final Category? category;
  final String? search;
  const CategoryPage({super.key, this.category, this.search});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: category?.name ?? 'Результаты поиска',
        category: category,
        searchActivate: true,
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ProductLoadedState) {
            var products = state.products.toList();
            if (category != null) {
              products = state.products
                  .where((product) => product.categoryId == category?.id)
                  .toList();
            } else {
              products = products
                  .where((product) => product.name
                      .toLowerCase()
                      .contains(search!.toLowerCase()))
                  .toList();
            }
            return SafeArea(
              child: products.isNotEmpty
                  ? Container(
                      margin: const EdgeInsetsDirectional.fromSTEB(
                          5.0, 20.0, 5.0, 0),
                      child: MasonryGridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return ProductCellWidget(
                            product: products[index],
                            inWishlist: false,
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: Text(
                        'Товары не найдены',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
            );
          } else {
            return const Text('Упс...Что-то пошло не по плану');
          }
        },
      ),
    );
  }
}
