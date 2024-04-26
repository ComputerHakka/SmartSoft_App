part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class UpdateOrderEvent extends OrderEvent {
  final UserModel? user;
  final Cart? cart;
  final String? addressId;

  const UpdateOrderEvent({this.user, this.cart, this.addressId});

  @override
  List<Object?> get props => [user, cart, addressId];
}

class ConfirmOrderEvent extends OrderEvent {
  final OrderModel order;

  const ConfirmOrderEvent({required this.order});

  @override
  List<Object?> get props => [order];
}
