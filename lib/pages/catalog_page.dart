import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smartsoft_application/models/category.dart';
import 'package:smartsoft_application/pages/filter_page.dart';
import 'package:smartsoft_application/theme/app_theme.dart';

import '../blocs/comparisonBloc/bloc/comparison_bloc.dart';
import '../blocs/filterBloc/bloc/filter_bloc.dart';
import '../blocs/productBloc/bloc/product_bloc.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/product_cell_widget.dart';
import 'comparison_page.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Каталог',
        searchActivate: true,
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, stateP) {
          if (stateP is ProductLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (stateP is ProductLoadedState) {
            var products = stateP.products.toList();
            return BlocBuilder<FilterBloc, FilterState>(
              builder: (context, stateF) {
                if (stateF is FilterLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (stateF is FilterLoadedState) {
                  return SafeArea(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await Future.delayed(const Duration(seconds: 1));
                        context.read<ProductBloc>().add(LoadProductsEvent());
                      },
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(
                          children: [
                            Flexible(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Stack(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ComparisonPage(),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.compare_rounded),
                                      ),
                                      BlocBuilder<ComparisonBloc,
                                          ComparisonState>(
                                        builder: (context, state) {
                                          if (state is ComparisonLoadedState) {
                                            return Positioned(
                                              top: 5,
                                              right: 5,
                                              child: CircleAvatar(
                                                radius: 9,
                                                backgroundColor: state
                                                        .comparison
                                                        .products
                                                        .isNotEmpty
                                                    ? kAccentColor
                                                    : Colors.transparent,
                                                child: Center(
                                                  child: state.comparison
                                                          .products.isNotEmpty
                                                      ? Text(
                                                          state.comparison
                                                              .products.length
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.white,
                                                          ),
                                                        )
                                                      : Container(),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const FilterPage(),
                                        ),
                                      );
                                    },
                                    label: const Text(
                                      'Фильтры',
                                    ),
                                    icon: const Icon(Icons.filter_list_rounded),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  )
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 13,
                              child: stateF.products.isNotEmpty
                                  ? Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: MasonryGridView.count(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 4,
                                        crossAxisSpacing: 4,
                                        itemCount: stateF.products.length,
                                        itemBuilder: (context, index) {
                                          return ProductCellWidget(
                                            product: stateF.products[index],
                                            inWishlist: false,
                                          );
                                        },
                                      ),
                                    )
                                  : const Center(
                                      child: Text(
                                        'Товары по запросу отсутствуют',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            );
          } else {
            return const Text('Упс...Что-то пошло не так');
          }
        },
      ),
    );
  }
}
