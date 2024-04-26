import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smartsoft_application/widgets/brand_card_widget.dart';
import 'package:smartsoft_application/widgets/custom_appbar.dart';

import '../blocs/brandBloc/bloc/brand_bloc.dart';

class AllBrandsPage extends StatelessWidget {
  const AllBrandsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Производители',
        searchActivate: false,
      ),
      body: BlocBuilder<BrandBloc, BrandState>(
        builder: (context, state) {
          if (state is BrandLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is BrandLoadedState) {
            var sortBrands = state.searchBrands;
            sortBrands.sort((a, b) => a.name.compareTo(b.name));
            return Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 10,
              ),
              child: Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: TextFormField(
                        onChanged: (value) {
                          context
                              .read<BrandBloc>()
                              .add(LoadBrandsEvent(searchText: value));
                        },
                        decoration: const InputDecoration(
                          hintText: 'Поиск производителя',
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          suffixIcon: Icon(Icons.search_rounded),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 7,
                    child: MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      itemCount: sortBrands.length,
                      itemBuilder: (context, index) {
                        return BrandCard(brand: sortBrands[index]);
                      },
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
    );
  }
}
