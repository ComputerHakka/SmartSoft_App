part of 'get_orders_bloc.dart';

abstract class GetOrdersState extends Equatable {
  const GetOrdersState();

  @override
  List<Object> get props => [];
}

class GetOrderLoadingState extends GetOrdersState {}

class GetOrderLoadedState extends GetOrdersState {
  final List<OrderModel> orders;

  const GetOrderLoadedState({this.orders = const <OrderModel>[]});

  @override
  List<Object> get props => [orders];
}

class GetOrderEmptyState extends GetOrdersState {}
