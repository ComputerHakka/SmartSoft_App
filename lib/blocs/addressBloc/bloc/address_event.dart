part of 'address_bloc.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

class LoadAddressesEvent extends AddressEvent {}

class UpdateAddressesEvent extends AddressEvent {
  final List<Address> addresses;
  final Address? selectedAddress;

  const UpdateAddressesEvent(this.addresses, {this.selectedAddress});

  @override
  List<Object?> get props => [addresses, selectedAddress];
}
