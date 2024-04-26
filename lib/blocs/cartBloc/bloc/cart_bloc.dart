import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/cart.dart';
import '../../../models/product.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartLoadingState()) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddProductEvent>(_onAddProduct);
    on<RemoveProductEvent>(_onRemoveProduct);
    on<ClearCartEvent>(_onClearEvent);
  }

  void _onLoadCart(
    LoadCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoadingState());
    try {
      emit(const CartLoadedState());
    } catch (_) {
      emit(CartErrorState());
    }
  }

  void _onAddProduct(
    AddProductEvent event,
    Emitter<CartState> emit,
  ) {
    if (state is CartLoadedState) {
      try {
        emit(
          CartLoadedState(
            cart: Cart(
              products: List.from((state as CartLoadedState).cart.products)
                ..add(event.product),
            ),
          ),
        );
      } on Exception {
        emit(CartErrorState());
      }
    }
  }

  void _onRemoveProduct(
    RemoveProductEvent event,
    Emitter<CartState> emit,
  ) {
    if (state is CartLoadedState) {
      try {
        emit(
          CartLoadedState(
            cart: Cart(
              products: List.from((state as CartLoadedState).cart.products)
                ..remove(event.product),
            ),
          ),
        );
      } on Exception {
        emit(CartErrorState());
      }
    }
  }

  void _onClearEvent(ClearCartEvent event, Emitter<CartState> emit) {
    emit(const CartLoadedState());
    emit(const CartLoadedState());
  }
}
