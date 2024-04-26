import '../../models/city.dart';

abstract class BaseCityRepository {
  Stream<List<City>> getAllCities();
}
