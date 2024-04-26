import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smartsoft_application/models/order.dart';
import 'package:smartsoft_application/models/user.dart';

import '../../../models/cart.dart';
import '../../../models/product.dart';
import '../../../repositories/order/order_repository.dart';
import '../../../utils/discount_calculator.dart';
import '../../authBloc/bloc/authorization_bloc.dart';
import '../../cartBloc/bloc/cart_bloc.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final AuthorizationBloc _authBloc;
  final CartBloc _cartBloc;
  final OrderRepository _orderRepository;
  StreamSubscription? _authSubscription;
  StreamSubscription? _cartSubscription;
  StreamSubscription? _orderSubscription;

  OrderBloc({
    required AuthorizationBloc authBloc,
    required CartBloc cartBloc,
    required OrderRepository orderRepository,
  })  : _authBloc = authBloc,
        _cartBloc = cartBloc,
        _orderRepository = orderRepository,
        super(
          cartBloc.state is CartLoadedState
              ? OrderLoadedState(
                  user: authBloc.state.user ?? UserModel.empty,
                  products: (cartBloc.state as CartLoadedState).cart.products,
                  addressId: 'ZVOICJ9Hb0woZIo0TUii',
                  totalPrice:
                      (cartBloc.state as CartLoadedState).cart.totalString -
                          DiscountCalculator()
                              .calculateDiscount(
                                  authBloc.state.user != null
                                      ? authBloc.state.user!.level
                                      : 1,
                                  (cartBloc.state as CartLoadedState)
                                      .cart
                                      .totalString
                                      .toDouble())
                              .round()
                              .toInt(),
                )
              : OrderLoadingState(),
        ) {
    on<UpdateOrderEvent>(_onUpdateOrder);
    on<ConfirmOrderEvent>(_onConfirmOrder);

    _authSubscription = _authBloc.stream.listen(
      (state) {
        if (state.status == AuthorizationStatus.unauthenticated) {
          add(const UpdateOrderEvent(user: UserModel.empty));
        } else {
          add(UpdateOrderEvent(user: state.user));
        }
      },
    );

    _cartSubscription = _cartBloc.stream.listen(
      (state) {
        if (state is CartLoadedState) {
          add(UpdateOrderEvent(cart: state.cart));
        }
      },
    );
  }

  void _onUpdateOrder(
    UpdateOrderEvent event,
    Emitter<OrderState> emit,
  ) {
    if (this.state is OrderLoadedState) {
      final state = this.state as OrderLoadedState;
      emit(
        OrderLoadedState(
          user: event.user ?? state.user,
          products: event.cart?.products ?? state.products,
          addressId: event.addressId ?? state.addressId,
          totalPrice: event.cart?.totalString ?? state.totalPrice,
        ),
      );
    }
  }

  void _onConfirmOrder(
    ConfirmOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    _orderSubscription?.cancel();
    if (this.state is OrderLoadedState) {
      try {
        await _orderRepository.addOrder(event.order);
        print('Done');
      } catch (_) {}
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    _cartSubscription?.cancel();
    return super.close();
  }
}
