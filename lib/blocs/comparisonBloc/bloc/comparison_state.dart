part of 'comparison_bloc.dart';

abstract class ComparisonState extends Equatable {
  const ComparisonState();

  @override
  List<Object> get props => [];
}

class ComparisonLoadingState extends ComparisonState {}

class ComparisonLoadedState extends ComparisonState {
  final Comparison comparison;

  const ComparisonLoadedState({this.comparison = const Comparison()});

  @override
  List<Object> get props => [comparison];
}

class ComparisonErrorState extends ComparisonState {
  @override
  List<Object> get props => [];
}
