import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsoft_application/widgets/product_cell_widget.dart';

import '../blocs/searchBloc/bloc/search_bloc.dart';
import '../models/brand.dart';
import '../models/category.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({
    Key? key,
    this.category,
    this.brand,
  }) : super(key: key);

  final Category? category;
  final Brand? brand;

  @override
  Widget build(BuildContext context) {
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
          return Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              bottom: 10,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Введите название товара',
                          contentPadding: EdgeInsets.all(10),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black45),
                          ),
                        ),
                        onChanged: (value) {
                          context.read<SearchBloc>().add(SearchProductEvent(
                                productName: value,
                                category: category,
                                brand: brand,
                              ));
                        },
                      ),
                    ),
                  ],
                ),
                state.products.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.products.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: ListTile(
                              title: Text(state.products[index].name),
                              onTap: () {},
                            ),
                          );
                        })
                    : const SizedBox(),
              ],
            ),
          );
        } else {
          return const Text('Упс...Что-то полшло не так');
        }
      },
    );
  }
}
