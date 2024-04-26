import '../../models/status.dart';

abstract class BaseStatusRepository {
  Stream<List<Status>> getAllStatuses();
}
