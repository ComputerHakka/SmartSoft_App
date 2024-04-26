part of 'address_bloc.dart';

abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object?> get props => [];
}

class AddressLoadingState extends AddressState {}

class AddressLoadedState extends AddressState {
  final List<Address> addresses;
  final Address? selectedAddress;

  const AddressLoadedState(
      {this.addresses = const <Address>[], this.selectedAddress});

  @override
  List<Object?> get props => [addresses, selectedAddress];
}
