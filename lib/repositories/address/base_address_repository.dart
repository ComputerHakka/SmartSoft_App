import '../../models/address.dart';

abstract class BaseAddressRepository {
  Stream<List<Address>> getAllAddresses();
}
