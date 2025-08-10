sealed class MapLoadStatus {
  const MapLoadStatus();
}

class MapLoadSuccess extends MapLoadStatus {
  const MapLoadSuccess();
}

class MapLoadFail extends MapLoadStatus {
  const MapLoadFail();
}
