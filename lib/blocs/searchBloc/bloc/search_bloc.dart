import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/brand.dart';
import '../../../models/category.dart';
import '../../../models/product.dart';
import '../../../models/wishlist.dart';
import '../../productBloc/bloc/product_bloc.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ProductBloc _productBloc;
  StreamSubscription? _productSubscription;

  SearchBloc({
    required ProductBloc productBloc,
  })  : _productBloc = productBloc,
        super(SearchLoadingState()) {
    on<LoadSearchEvent>(_onLoadSearch);
    on<SearchProductEvent>(_onSearchProduct);
    on<UpdateResultsEvent>(_onUpdateResults);
  }

  void _onLoadSearch(
    LoadSearchEvent event,
    Emitter<SearchState> emit,
  ) {
    emit(const SearchLoadedState());
  }

  void _onSearchProduct(
    SearchProductEvent event,
    Emitter<SearchState> emit,
  ) {
    List<Product> products =
        (_productBloc.state as ProductLoadedState).products;

    if (event.category != null) {
      products = products
          .where((product) => product.categoryId == event.category!.id)
          .toList();
    }

    if (event.brand != null) {
      products = products
          .where((product) => product.brandId == event.brand!.id)
          .toList();
    }

    if (event.wishlist != null) {}

    if (event.productName.isNotEmpty) {
      List<Product> searchResults = products
          .where((product) => product.name
              .toLowerCase()
              .contains(event.productName.toLowerCase()))
          .toList();

      emit(SearchLoadedState(products: searchResults));
    } else {
      emit(SearchLoadedState(products: products));
    }
  }

  void _onUpdateResults(
    UpdateResultsEvent event,
    Emitter<SearchState> emit,
  ) {}

  @override
  Future<void> close() async {
    _productSubscription?.cancel();
    super.close();
  }
}
