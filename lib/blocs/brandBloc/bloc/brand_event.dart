part of 'brand_bloc.dart';

abstract class BrandEvent extends Equatable {
  const BrandEvent();

  @override
  List<Object?> get props => [];
}

class LoadBrandsEvent extends BrandEvent {
  final String? searchText;

  const LoadBrandsEvent({this.searchText});
  @override
  List<Object?> get props => [searchText];
}

class UpdateBrandsEvent extends BrandEvent {
  final List<Brand> brands;
  final List<Brand> searchBrands;

  const UpdateBrandsEvent({required this.brands, required this.searchBrands});

  @override
  List<Object?> get props => [brands, searchBrands];
}
