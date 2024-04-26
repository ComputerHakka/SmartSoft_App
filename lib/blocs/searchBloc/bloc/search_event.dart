part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class LoadSearchEvent extends SearchEvent {}

class SearchProductEvent extends SearchEvent {
  final String productName;
  final Category? category;
  final Brand? brand;
  final Wishlist? wishlist;

  const SearchProductEvent({
    required this.productName,
    this.category,
    this.brand,
    this.wishlist,
  });

  @override
  List<Object?> get props => [productName, category, brand, wishlist];
}

class UpdateResultsEvent extends SearchEvent {
  final List<Product> products;

  const UpdateResultsEvent(this.products);

  @override
  List<Object?> get props => [products];
}
