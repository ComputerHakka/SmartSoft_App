part of 'filter_bloc.dart';

abstract class FilterState extends Equatable {
  const FilterState();

  @override
  List<Object?> get props => [];
}

class FilterLoadingState extends FilterState {}

class FilterLoadedState extends FilterState {
  final List<Product> products;
  final String? productName;
  final Category? category;
  final List<Brand>? brands;
  final int? minPrice;
  final int? maxPrice;
  final bool sortByName;
  final bool sortByPrice;
  final bool sortNameDescending;
  final bool sortPriceDescending;

  const FilterLoadedState({
    this.products = const <Product>[],
    this.productName,
    this.category,
    this.brands,
    this.minPrice,
    this.maxPrice,
    this.sortByName = true,
    this.sortByPrice = false,
    this.sortNameDescending = false,
    this.sortPriceDescending = false,
  });

  @override
  List<Object?> get props => [
        products,
        productName,
        maxPrice,
        minPrice,
        category,
        brands,
        sortNameDescending,
        sortPriceDescending,
        sortByName,
        sortByPrice,
      ];
}
