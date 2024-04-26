import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smartsoft_application/models/brand.dart';
import 'package:smartsoft_application/repositories/brand/brand_repository.dart';

part 'brand_event.dart';
part 'brand_state.dart';

class BrandBloc extends Bloc<BrandEvent, BrandState> {
  final BrandRepository _brandRepository;
  StreamSubscription? _brandSubscription;
  BrandBloc({required BrandRepository brandRepository})
      : _brandRepository = brandRepository,
        super(BrandLoadingState()) {
    on<LoadBrandsEvent>(_onLoadBrands);
    on<UpdateBrandsEvent>(_onUpdateBrands);
  }

  void _onLoadBrands(LoadBrandsEvent event, Emitter<BrandState> emit) {
    _brandSubscription?.cancel();
    _brandSubscription = _brandRepository.getAllBrands().listen((brands) {
      if (event.searchText != null && event.searchText != '') {
        add(
          UpdateBrandsEvent(
              brands: brands,
              searchBrands: brands
                  .where((brand) => brand.name
                      .toLowerCase()
                      .contains(event.searchText!.toLowerCase()))
                  .toList()),
        );
      } else {
        add(
          UpdateBrandsEvent(brands: brands, searchBrands: brands),
        );
      }
    });
  }

  void _onUpdateBrands(UpdateBrandsEvent event, Emitter<BrandState> emit) {
    emit(BrandLoadedState(
        brands: event.brands, searchBrands: event.searchBrands));
  }
}
