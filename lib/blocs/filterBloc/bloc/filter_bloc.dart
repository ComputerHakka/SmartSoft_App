import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/brand.dart';
import '../../../models/category.dart';
import '../../../models/product.dart';
import '../../productBloc/bloc/product_bloc.dart';

part 'filter_event.dart';
part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final ProductBloc _productBloc;
  StreamSubscription? _productSubscription;
  FilterBloc({
    required ProductBloc productBloc,
  })  : _productBloc = productBloc,
        super(FilterLoadingState()) {
    on<LoadFilterEvent>(_onLoadFilter);
    on<FilterProductEvent>(_onFilterProduct);
    on<UpdateResultsEvent>(_onUpdateResults);
  }

  void _onLoadFilter(
    LoadFilterEvent event,
    Emitter<FilterState> emit,
  ) {
    add(const FilterProductEvent());
  }

  void _onFilterProduct(
    FilterProductEvent event,
    Emitter<FilterState> emit,
  ) {
    List<Product> products =
        (_productBloc.state as ProductLoadedState).products;

    products = products
        .where((product) =>
            product.price <= event.maxPrice && product.price >= event.minPrice)
        .toList();

    if (event.category != null) {
      products = products
          .where((product) => product.categoryId == event.category!.id)
          .toList();
    }

    if (event.brands.isNotEmpty) {
      products = products
          .where((product) =>
              event.brands.any((brand) => brand.id == product.brandId))
          .toList();
    }

    if (event.sortByName) {
      if (event.sortNameDescending) {
        products.sort((a, b) => b.name.compareTo(a.name));
      } else {
        products.sort((a, b) => a.name.compareTo(b.name));
      }
    }

    if (event.sortByPrice) {
      if (event.sortPriceDescending) {
        products.sort((a, b) => b.price.compareTo(a.price));
      } else {
        products.sort((a, b) => a.price.compareTo(b.price));
      }
    }

    if (event.productName != null && event.productName!.isNotEmpty) {
      List<Product> filterResults = products
          .where((product) => product.name
              .toLowerCase()
              .contains(event.productName!.toLowerCase()))
          .toList();

      emit(FilterLoadedState(
        products: filterResults,
        minPrice: event.minPrice,
        maxPrice: event.maxPrice,
        brands: event.brands,
        category: event.category,
        sortByName: event.sortByName,
        sortByPrice: event.sortByPrice,
        sortNameDescending: event.sortNameDescending,
        sortPriceDescending: event.sortPriceDescending,
      ));
    } else {
      emit(FilterLoadedState(
        products: products,
        minPrice: event.minPrice,
        maxPrice: event.maxPrice,
        brands: event.brands,
        category: event.category,
        sortByName: event.sortByName,
        sortByPrice: event.sortByPrice,
        sortNameDescending: event.sortNameDescending,
        sortPriceDescending: event.sortPriceDescending,
      ));
    }
  }

  void _onUpdateResults(
    UpdateResultsEvent event,
    Emitter<FilterState> emit,
  ) {}

  @override
  Future<void> close() async {
    _productSubscription?.cancel();
    super.close();
  }
}
