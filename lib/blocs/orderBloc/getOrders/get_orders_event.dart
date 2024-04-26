part of 'get_orders_bloc.dart';

abstract class GetOrdersEvent extends Equatable {
  const GetOrdersEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrdersEvent extends GetOrdersEvent {
  final UserModel? user;

  const LoadOrdersEvent({this.user});

  @override
  List<Object?> get props => [user];
}

class UpdateOrdersEvent extends GetOrdersEvent {
  final List<OrderModel> orders;

  const UpdateOrdersEvent(this.orders);

  @override
  List<Object> get props => [orders];
}

class ZeroOrdersEvent extends GetOrdersEvent {}
