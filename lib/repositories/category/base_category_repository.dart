import 'package:smartsoft_application/models/category.dart';

abstract class BaseCategoryRepository {
  Stream<List<Category>> getAllCategories();
}
