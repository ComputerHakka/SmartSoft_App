import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/city.dart';
import '../../../repositories/city/city_repository.dart';

part 'city_event.dart';
part 'city_state.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  final CityRepository _cityRepository;
  StreamSubscription? _citySubscription;
  CityBloc({required CityRepository cityRepository})
      : _cityRepository = cityRepository,
        super(CityLoadingState()) {
    on<LoadCitiesEvent>(_onLoadCities);
    on<UpdateCitiesEvent>(_onUpdateCities);
  }

  void _onLoadCities(LoadCitiesEvent event, Emitter<CityState> emit) {
    _citySubscription?.cancel();
    _citySubscription = _cityRepository.getAllCities().listen(
          (cities) => add(
            UpdateCitiesEvent(cities),
          ),
        );
  }

  void _onUpdateCities(UpdateCitiesEvent event, Emitter<CityState> emit) {
    emit(CityLoadedState(
        cities: event.cities, selectedCity: event.selectedCity));
  }
}
