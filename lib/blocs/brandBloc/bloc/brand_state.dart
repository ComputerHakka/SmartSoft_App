part of 'brand_bloc.dart';

abstract class BrandState extends Equatable {
  const BrandState();

  @override
  List<Object?> get props => [];
}

class BrandLoadingState extends BrandState {}

class BrandLoadedState extends BrandState {
  final List<Brand> brands;
  final List<Brand> searchBrands;

  const BrandLoadedState({
    this.brands = const <Brand>[],
    required this.searchBrands,
  });

  @override
  List<Object?> get props => [brands, searchBrands];
}
