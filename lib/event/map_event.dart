import 'package:naver_maps_sdk_flutter/model/n_lat_lng.dart';
import 'package:naver_maps_sdk_flutter/model/n_point.dart';

sealed class MapEvent {
  const MapEvent();
}

class MapClick extends MapEvent {
  final NLatLng latLng;
  final NPoint point;
  const MapClick(this.latLng, this.point);
}

class MapLongTap extends MapEvent {
  final NLatLng latLng;
  final NPoint point;
  const MapLongTap(this.latLng, this.point);
}

class MapIdle extends MapEvent {
  const MapIdle();
}

class MapZoomChanged extends MapEvent {
  final int zoom;
  const MapZoomChanged(this.zoom);
}

class MapZoomEnd extends MapEvent {
  const MapZoomEnd();
}

class MapZoomStart extends MapEvent {
  const MapZoomStart();
}

class MapCenterChanged extends MapEvent {
  final NLatLng latLng;
  final NPoint point;
  const MapCenterChanged(this.latLng, this.point);
}