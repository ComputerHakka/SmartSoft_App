import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/comparison.dart';
import '../../../models/product.dart';

part 'comparison_event.dart';
part 'comparison_state.dart';

class ComparisonBloc extends Bloc<ComparisonEvent, ComparisonState> {
  ComparisonBloc() : super(ComparisonLoadingState()) {
    on<LoadComparisonEvent>(_onLoadComparison);
    on<AddProductToComparisonEvent>(_onAddProduct);
    on<RemoveProductFromComparisonEvent>(_onRemoveProduct);
  }
  void _onLoadComparison(
    LoadComparisonEvent event,
    Emitter<ComparisonState> emit,
  ) async {
    emit(ComparisonLoadingState());
    try {
      await Future<void>.delayed(const Duration(seconds: 1));
      emit(const ComparisonLoadedState());
    } catch (_) {
      emit(ComparisonErrorState());
    }
  }

  void _onAddProduct(
    AddProductToComparisonEvent event,
    Emitter<ComparisonState> emit,
  ) {
    if (state is ComparisonLoadedState) {
      try {
        emit(
          ComparisonLoadedState(
            comparison: Comparison(
              products: List.from(
                  (state as ComparisonLoadedState).comparison.products)
                ..add(event.product),
            ),
          ),
        );
      } on Exception {
        emit(ComparisonErrorState());
      }
    }
  }

  void _onRemoveProduct(
    RemoveProductFromComparisonEvent event,
    Emitter<ComparisonState> emit,
  ) {
    if (state is ComparisonLoadedState) {
      try {
        emit(
          ComparisonLoadedState(
            comparison: Comparison(
              products: List.from(
                  (state as ComparisonLoadedState).comparison.products)
                ..remove(event.product),
            ),
          ),
        );
      } on Exception {
        emit(ComparisonErrorState());
      }
    }
  }
}
