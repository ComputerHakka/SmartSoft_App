part of 'city_bloc.dart';

abstract class CityEvent extends Equatable {
  const CityEvent();

  @override
  List<Object?> get props => [];
}

class LoadCitiesEvent extends CityEvent {}

class UpdateCitiesEvent extends CityEvent {
  final List<City> cities;
  final City? selectedCity;

  const UpdateCitiesEvent(this.cities, {this.selectedCity});

  @override
  List<Object?> get props => [cities, selectedCity];
}
