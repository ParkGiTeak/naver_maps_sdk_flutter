import '../model/bounds.dart';
import '../model/coord.dart';
import '../model/marker_options.dart';
import '../model/n_lat_lng_bounds.dart';
import '../model/n_point_bounds.dart';

abstract interface class NaverMapManagerInterface {
  void onMapLoadSuccess();

  void onMapLoadFail();

  void onMarkerClick(int markerId);

  void onMapClick(Map<String, dynamic> coord);

  void onMapLongTap(Map<String, dynamic> coord);

  void onMapIdle();

  void onMapZoomChanged(int zoom);

  void onMapZoomEnd();

  void onMapZoomStart();

  void onMapCenterChanged(Map<String, dynamic> center);

  void dispose();

  Future<Coord> getCenter({required bool shouldReturnLatLng});

  Future<int> getZoom();

  Future<Bounds> getBounds({required bool shouldReturnLatLng});

  Future<bool> hasLatLng({required NLatLngBounds bounds, required Coord coord});

  Future<bool> hasPoint({required NPointBounds bounds, required Coord coord});

  Future<void> setCenter({required Coord center});

  Future<void> setZoom({required int zoom});

  Future<void> addMarker({
    required String markerId,
    required MarkerOptions markerOptions,
  });

  Future<void> updateMarker({
    required String markerId,
    required MarkerOptions markerOptions,
  });

  Future<void> removeMarker({required String markerId});

  Future<void> removeMarkerAll();

  Future<List<int>> getMarkerIds();

  Future<void> addMarkerClickEvent({required String markerId});

  Future<void> removeMarkerClickEvent({required String markerId});

  Future<void> addMapClickEventListener();

  Future<void> removeMapClickEventListener();

  Future<void> addMapLongTapEventListener();

  Future<void> removeMapLongTapEventListener();

  Future<void> addMapIdleEventListener();

  Future<void> removeMapIdleEventListener();

  Future<void> addMapZoomChangedEventListener();

  Future<void> removeMapZoomChangedEventListener();

  Future<void> addMapZoomEndEventListener();

  Future<void> removeMapZoomEndEventListener();

  Future<void> addMapZoomStartEventListener();

  Future<void> removeMapZoomStartEventListener();

  Future<void> addMapCenterChangedEventListener();

  Future<void> removeMapCenterChangedEventListener();

  Future<void> disposeMap();
}
