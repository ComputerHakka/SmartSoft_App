part of 'filter_bloc.dart';

abstract class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object?> get props => [];
}

class LoadFilterEvent extends FilterEvent {}

class FilterProductEvent extends FilterEvent {
  final String? productName;
  final Category? category;
  final List<Brand> brands;
  final int minPrice;
  final int maxPrice;
  final bool sortNameDescending;
  final bool sortPriceDescending;
  final bool sortByName;
  final bool sortByPrice;

  const FilterProductEvent({
    this.productName,
    this.category,
    this.brands = const <Brand>[],
    this.minPrice = 1000,
    this.maxPrice = 300000,
    this.sortByName = true,
    this.sortByPrice = false,
    this.sortNameDescending = false,
    this.sortPriceDescending = false,
  });

  @override
  List<Object?> get props => [
        productName,
        category,
        brands,
        minPrice,
        maxPrice,
        sortNameDescending,
        sortPriceDescending,
        sortByName,
        sortByPrice
      ];
}

class UpdateResultsEvent extends FilterEvent {
  final List<Product> products;

  const UpdateResultsEvent(this.products);

  @override
  List<Object?> get props => [products];
}
