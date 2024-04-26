part of 'comparison_bloc.dart';

abstract class ComparisonEvent extends Equatable {
  const ComparisonEvent();

  @override
  List<Object> get props => [];
}

class LoadComparisonEvent extends ComparisonEvent {}

class AddProductToComparisonEvent extends ComparisonEvent {
  final Product product;

  const AddProductToComparisonEvent(this.product);

  @override
  List<Object> get props => [product];
}

class RemoveProductFromComparisonEvent extends ComparisonEvent {
  final Product product;

  const RemoveProductFromComparisonEvent(this.product);

  @override
  List<Object> get props => [product];
}

class ClearComparisonEvent extends ComparisonEvent {}
