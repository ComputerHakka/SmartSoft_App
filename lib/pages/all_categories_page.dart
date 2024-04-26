import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsoft_application/widgets/custom_appbar.dart';
import 'package:smartsoft_application/widgets/hero_carousel_card_widget.dart';

import '../blocs/categoryBloc/bloc/category_bloc.dart';

class AllCategoriesPage extends StatelessWidget {
  const AllCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Категории',
        searchActivate: false,
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is CategoryLoadedState) {
            var sortCategories = state.categories;
            sortCategories.sort((a, b) => a.name.compareTo(b.name));
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              width: double.infinity,
              height: double.infinity,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: sortCategories.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                      height: 210,
                      child: HeroCarouselCard(category: sortCategories[index]));
                },
              ),
            );
          } else {
            return const Center(
              child: Text('Упс...Что-то пошло не так'),
            );
          }
        },
      ),
    );
  }
}
