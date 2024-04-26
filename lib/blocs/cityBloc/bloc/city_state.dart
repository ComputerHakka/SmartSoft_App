part of 'city_bloc.dart';

abstract class CityState extends Equatable {
  const CityState();

  @override
  List<Object?> get props => [];
}

class CityLoadingState extends CityState {}

class CityLoadedState extends CityState {
  final List<City> cities;
  final City? selectedCity;

  const CityLoadedState({
    this.cities = const <City>[],
    this.selectedCity,
  });

  @override
  List<Object?> get props => [cities, selectedCity];
}
