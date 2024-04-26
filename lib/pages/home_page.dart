import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsoft_application/blocs/brandBloc/bloc/brand_bloc.dart';
import 'package:smartsoft_application/pages/all_brands_page.dart';
import 'package:smartsoft_application/pages/all_categories_page.dart';
import 'package:smartsoft_application/pages/comparison_page.dart';
import 'package:smartsoft_application/widgets/brand_card_widget.dart';
import 'package:smartsoft_application/widgets/hero_carousel_card_widget.dart';

import '../blocs/categoryBloc/bloc/category_bloc.dart';
import '../blocs/productBloc/bloc/product_bloc.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/product_cell_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Главная',
        searchActivate: true,
      ),
      body: ListView(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllCategoriesPage(),
                ),
              );
            },
            child: Container(
              color: Colors.transparent,
              margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Категории',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllCategoriesPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward_rounded),
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          ),
          Container(
            child: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is CategoryLoadedState) {
                  return CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: 2.0,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      autoPlayInterval: const Duration(seconds: 5),
                      initialPage: 2,
                      autoPlay: true,
                    ),
                    items: state.categories
                        .map((category) => HeroCarouselCard(category: category))
                        .toList()
                        .sublist(0, 5),
                  );
                } else {
                  return const Text('Упс...Что-то пошло не так');
                }
              },
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllBrandsPage(),
                ),
              );
            },
            child: Container(
              color: Colors.transparent,
              margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Производители',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllBrandsPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward_rounded),
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 200,
            child: BlocBuilder<BrandBloc, BrandState>(
              builder: (context, state) {
                if (state is BrandLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is BrandLoadedState) {
                  var brands = state.brands.toList().sublist(0, 5);
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: brands.length,
                    itemBuilder: (context, index) {
                      return BrandCard(brand: brands[index]);
                    },
                  );
                } else {
                  return const Text('Упс...Что-то пошло не так');
                }
              },
            ),
          ),
          Container(
            color: Colors.transparent,
            margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Советуем купить',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 380,
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is ProductLoadedState) {
                  var products = state.products.toList().sublist(0, 2);
                  return ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: products.length,
                      itemBuilder: ((context, index) {
                        return ProductCellWidget(
                          product: products[index],
                          inWishlist: false,
                        );
                      }));
                }
                return Container();
              },
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
