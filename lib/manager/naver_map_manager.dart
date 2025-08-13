part of '../naver_maps_sdk_flutter.dart';

class NaverMapManager {
  final WebViewController _controller = WebViewController();

  final _mapLoadStatusController = StreamController<MapLoadStatus>.broadcast();
  final _markerEventController = StreamController<MarkerEvent>.broadcast();

  Stream<MapLoadStatus> get onMapLoadStatus => _mapLoadStatusController.stream;

  Stream<MarkerEvent> get onMarkerEvent => _markerEventController.stream;

  NaverMapManager._internal();

  void onMapLoadSuccess() {
    _mapLoadStatusController.add(const MapLoadSuccess());
  }

  void onMapLoadFail() {
    _mapLoadStatusController.add(const MapLoadFail());
  }

  void onMarkerClick(int markerId) {
    _markerEventController.add(MarkerClick(markerId));
  }

  void dispose() {
    _mapLoadStatusController.close();
    _markerEventController.close();
  }

  Future<Coord> getCenter({required bool resultTypeLatLng}) async {
    String jsonStringResult =
        await _controller.runJavaScriptReturningResult('map.getCenter()')
            as String;
    if (Platform.isIOS) {
      jsonStringResult = NSDictionaryUtil.convert(jsonStringResult);
    }
    final Map<String, dynamic> json = jsonDecode(jsonStringResult);
    if (resultTypeLatLng) {
      final Coord coord = NLatLng(json['_lat'], json['_lng']);
      return coord;
    } else {
      final Coord coord = NPoint(json['x'], json['y']);
      return coord;
    }
  }

  Future<int> getZoom() async {
    final num jsonStringResult =
        await _controller.runJavaScriptReturningResult('map.getZoom()') as num;
    return jsonStringResult.toInt();
  }

  Future<Bounds> getBounds({required bool resultTypeLatLng}) async {
    String jsonStringResult =
        await _controller.runJavaScriptReturningResult('map.getBounds()')
            as String;
    if (Platform.isIOS) {
      jsonStringResult = NSDictionaryUtil.convert(jsonStringResult);
    }
    final Map<String, dynamic> json = jsonDecode(jsonStringResult);
    final Bounds bounds;
    if (resultTypeLatLng) {
      bounds = NLatLngBounds(
        southWest: NLatLng(json['_sw']['_lat'], json['_sw']['_lng']),
        northEast: NLatLng(json['_ne']['_lat'], json['_ne']['_lng']),
      );
    } else {
      bounds = NPointBounds(
        min: NPoint(json['_min']['x'], json['_min']['y']),
        max: NPoint(json['_max']['x'], json['_max']['y']),
      );
    }
    return bounds;
  }

  Future<bool> hasLatLng({
    required NLatLngBounds bounds,
    required Coord coord,
  }) async {
    final bool jsonStringResult =
        await _controller.runJavaScriptReturningResult(
              'window.hasLatLng(${bounds.toJson()}, ${coord.toJson()})',
            )
            as bool;
    return jsonStringResult;
  }

  Future<bool> hasPoint({
    required NPointBounds bounds,
    required Coord coord,
  }) async {
    final bool jsonStringResult =
        await _controller.runJavaScriptReturningResult(
              'window.hasPoint(${bounds.toJson()}, ${coord.toJson()})',
            )
            as bool;
    return jsonStringResult;
  }

  Future<void> setCenter({required Coord center}) async {
    await _controller.runJavaScript('map.setCenter(${center.toJson()})');
  }

  Future<void> setZoom({required int zoom}) async {
    await _controller.runJavaScript('map.setZoom($zoom)');
  }

  Future<void> addMarker({
    required int markerId,
    required MarkerOptions markerOptions,
  }) async {
    await _controller.runJavaScript(
      'window.addMarker($markerId, ${markerOptions.toJson()})',
    );
  }

  Future<void> updateMarker({
    required int markerId,
    required MarkerOptions markerOptions,
  }) async {
    await _controller.runJavaScript(
      'window.updateMarker($markerId, ${markerOptions.toJson()})',
    );
  }

  Future<void> removeMarker({required int markerId}) async {
    await _controller.runJavaScript('window.removeMarker($markerId)');
  }

  Future<void> removeMarkerAll() async {
    await _controller.runJavaScript('window.removeMarkerAll()');
  }

  Future<List<int>> getMarkerIds() async {
    String jsonStringResult =
        await _controller.runJavaScriptReturningResult('window.getMarkerIds()')
            as String;
    if (Platform.isIOS) {
      jsonStringResult = NSDictionaryUtil.convert(jsonStringResult);
    }
    final List<dynamic> markerIds = jsonDecode(jsonStringResult);
    return markerIds.cast<int>();
  }

  Future<void> addMarkerClickEvent({required int markerId}) async {
    await _controller.runJavaScript('window.addMarkerClickEvent($markerId)');
  }

  Future<void> removeMarkerClickEvent({required int markerId}) async {
    await _controller.runJavaScript('window.removeMarkerClickEvent($markerId)');
  }
}
