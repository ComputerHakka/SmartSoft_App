import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/address.dart';
import '../../../repositories/address/address_repository.dart';

part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressRepository _addressRepository;
  StreamSubscription? _addressSubscription;
  AddressBloc({required AddressRepository addressRepository})
      : _addressRepository = addressRepository,
        super(AddressLoadingState()) {
    on<LoadAddressesEvent>(_onLoadAddresses);
    on<UpdateAddressesEvent>(_onUpdateAddresses);
  }

  void _onLoadAddresses(event, Emitter<AddressState> emit) {
    _addressSubscription?.cancel();
    _addressSubscription = _addressRepository.getAllAddresses().listen(
          (addresses) => add(
            UpdateAddressesEvent(addresses),
          ),
        );
  }

  void _onUpdateAddresses(
      UpdateAddressesEvent event, Emitter<AddressState> emit) {
    emit(AddressLoadedState(
        addresses: event.addresses, selectedAddress: event.selectedAddress));
  }
}
