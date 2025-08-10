sealed class MarkerEvent {
  const MarkerEvent();
}

class MarkerClick extends MarkerEvent {
  final int markerId;
  const MarkerClick(this.markerId);
}
