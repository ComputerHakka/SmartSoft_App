import 'package:smartsoft_application/models/brand.dart';

abstract class BaseBrandRepository {
  Stream<List<Brand>> getAllBrands();
}
