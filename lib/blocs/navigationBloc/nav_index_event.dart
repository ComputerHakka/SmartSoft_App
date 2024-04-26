class NavIndexEvent {}

class SetIndexEvent extends NavIndexEvent {
  final int index;
  SetIndexEvent({required this.index});
}
