part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderLoadingState extends OrderState {}

class OrderLoadedState extends OrderState {
  final UserModel? user;
  final List<Product>? products;
  final String? addressId;
  final int? totalPrice;
  final OrderModel order;

  OrderLoadedState({
    this.user = UserModel.empty,
    this.products,
    this.addressId,
    this.totalPrice,
  }) : order = OrderModel(
          user: user,
          products: products,
          addressId: addressId,
          totalPrice: totalPrice,
        );

  @override
  List<Object?> get props => [
        user,
        products,
        addressId,
        totalPrice,
        order,
      ];
}
