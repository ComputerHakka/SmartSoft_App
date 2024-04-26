import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smartsoft_application/pages/user_edit_page.dart';
import 'package:smartsoft_application/widgets/product_cell_widget.dart';
import 'package:smartsoft_application/widgets/search_box_widget.dart';

import '../blocs/authBloc/bloc/authorization_bloc.dart';
import '../blocs/searchBloc/bloc/search_bloc.dart';
import '../models/brand.dart';
import '../models/category.dart';
import '../models/wishlist.dart';
import '../pages/product_page.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  final String title;
  final Brand? brand;
  final Category? category;
  final Wishlist? wishlist;
  final bool searchActivate;
  final bool profilePage;
  const CustomAppBar(
      {super.key,
      required this.title,
      this.brand,
      this.category,
      this.wishlist,
      this.searchActivate = true,
      this.profilePage = false});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}

class _CustomAppBarState extends State<CustomAppBar> {
  late Widget titleWidget;

  @override
  Widget build(BuildContext context) {
    var userState = context.read<AuthorizationBloc>().state;
    bool userAuth = true;
    if (userState.status == AuthorizationStatus.unauthenticated) {
      userAuth = false;
    }
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      title: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: HexColor('1E1E1E')),
        child: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        if (widget.searchActivate)
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: AppSearchDelegate(
                  searchBloc: BlocProvider.of<SearchBloc>(context),
                  brand: widget.brand,
                  category: widget.category,
                ),
              );
            },
            icon: const Icon(
              Icons.search,
              size: 33,
            ),
          ),
        if (widget.profilePage)
          BlocBuilder<AuthorizationBloc, AuthorizationState>(
            builder: (context, state) {
              if (state.status == AuthorizationStatus.authenticated) {
                return IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserEditPage(
                          user: state.user!,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.drive_file_rename_outline_rounded,
                    size: 33,
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
      ],
    );
  }
}

class AppSearchDelegate extends SearchDelegate {
  Brand? brand;
  Category? category;
  SearchBloc searchBloc;
  AppSearchDelegate({
    required this.searchBloc,
    this.brand,
    this.category,
  });

  @override
  String get searchFieldLabel => 'Введите название';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
        icon: const Icon(
          Icons.clear,
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (brand != null) {
      searchBloc.add(SearchProductEvent(productName: query, brand: brand));
    }
    if (category != null) {
      searchBloc
          .add(SearchProductEvent(productName: query, category: category));
    } else {
      searchBloc.add(SearchProductEvent(productName: query));
    }

    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoadingState) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
        }
        if (state is SearchLoadedState) {
          return state.products.isNotEmpty
              ? MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    return ProductCellWidget(
                      product: state.products[index],
                      inWishlist: false,
                    );
                  },
                )
              : const Center(
                  child: Text(
                    'Результаты поиска отсутствуют :(',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                );
        } else {
          return const Text('Упс...Что-то полшло не так');
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (brand != null) {
      searchBloc.add(SearchProductEvent(productName: query, brand: brand));
    }
    if (category != null) {
      searchBloc
          .add(SearchProductEvent(productName: query, category: category));
    } else {
      searchBloc.add(SearchProductEvent(productName: query));
    }
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoadingState) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
        }
        if (state is SearchLoadedState) {
          return state.products.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: ListTile(
                        title: Text(state.products[index].name),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductPage(
                                product: state.products[index],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  })
              : const Center(
                  child: Text(
                    'Результаты поиска отсутствуют :(',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                );
        } else {
          return const Text('Упс...Что-то полшло не так');
        }
      },
    );
  }
}
