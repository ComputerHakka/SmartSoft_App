import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smartsoft_application/models/category.dart';
import 'package:smartsoft_application/repositories/category/category_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository;
  StreamSubscription? _categorySubscription;
  CategoryBloc({required CategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository,
        super(CategoryLoadingState()) {
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<UpdateCategoriesEvent>(_onUpdateCategories);
  }

  void _onLoadCategories(event, Emitter<CategoryState> emit) {
    _categorySubscription?.cancel();
    _categorySubscription = _categoryRepository.getAllCategories().listen(
          (categories) => add(
            UpdateCategoriesEvent(categories),
          ),
        );
  }

  void _onUpdateCategories(
      UpdateCategoriesEvent event, Emitter<CategoryState> emit) {
    emit(CategoryLoadedState(categories: event.categories));
  }
}
