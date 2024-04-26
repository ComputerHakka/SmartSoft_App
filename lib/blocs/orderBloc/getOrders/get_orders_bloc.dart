import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smartsoft_application/models/user.dart';
import 'package:smartsoft_application/repositories/order/order_repository.dart';

import '../../../models/order.dart';
import '../../authBloc/bloc/authorization_bloc.dart';

part 'get_orders_event.dart';
part 'get_orders_state.dart';

class GetOrdersBloc extends Bloc<GetOrdersEvent, GetOrdersState> {
  final OrderRepository _orderRepository;
  final AuthorizationBloc _authorizationBloc;
  StreamSubscription? _orderSubscription;
  StreamSubscription? _authSubscription;
  GetOrdersBloc(
      {required OrderRepository orderRepository,
      required AuthorizationBloc authorizationBloc})
      : _orderRepository = orderRepository,
        _authorizationBloc = authorizationBloc,
        super(GetOrderLoadingState()) {
    on<LoadOrdersEvent>(_onLoadOrders);
    on<UpdateOrdersEvent>(_onUpdateOrders);

    _authSubscription = _authorizationBloc.stream.listen((state) {
      if (state.user != null) {
        add(LoadOrdersEvent(user: state.user!));
      }
    });
  }

  void _onLoadOrders(LoadOrdersEvent event, Emitter<GetOrdersState> emit) {
    if (event.user != null) {
      _orderSubscription?.cancel();
      _orderSubscription = _orderRepository.getAllOrders().listen(
            (orders) => add(
              UpdateOrdersEvent(orders
                  .where((order) => order.clientEmail == event.user!.email)
                  .toList()),
            ),
          );
    } else {
      emit(const GetOrderLoadedState());
    }
  }

  void _onUpdateOrders(UpdateOrdersEvent event, Emitter<GetOrdersState> emit) {
    if (event.orders.isNotEmpty) {
      emit(GetOrderLoadedState(orders: event.orders));
    } else {
      emit(const GetOrderLoadedState());
    }
  }

  @override
  Future<void> close() async {
    _authSubscription?.cancel();
    super.close();
  }
}
