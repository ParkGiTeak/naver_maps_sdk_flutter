sealed class MarkerEvent {
  const MarkerEvent();
}

class MarkerClick extends MarkerEvent {
  final String markerId;
  const MarkerClick(this.markerId);
}
