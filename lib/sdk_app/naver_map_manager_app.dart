part of 'naver_maps_sdk_flutter_app.dart';

class NaverMapManager implements NaverMapManagerInterface {
  final WebViewController _controller = WebViewController();

  StreamController<MapLoadStatus>? _mapLoadStatusController;
  StreamController<MarkerEvent>? _markerEventController;
  StreamController<MapEvent>? _mapEventController;

  Stream<MapLoadStatus> get onMapLoadStatus {
    _mapLoadStatusController = StreamController<MapLoadStatus>.broadcast();
    return _mapLoadStatusController!.stream;
  }

  Stream<MarkerEvent> get onMarkerEvent {
    _markerEventController = StreamController<MarkerEvent>.broadcast();
    return _markerEventController!.stream;
  }

  Stream<MapEvent> get onMapEvent {
    _mapEventController = StreamController<MapEvent>.broadcast();
    return _mapEventController!.stream;
  }

  NaverMapManager._internal();

  static NaverMapManager createNaverMapManager() {
    return NaverMapManager._internal();
  }

  @override
  void onMapLoadSuccess() {
    _mapLoadStatusController?.add(const MapLoadSuccess());
  }

  @override
  void onMapLoadFail() {
    _mapLoadStatusController?.add(const MapLoadFail());
  }

  @override
  void onMarkerClick(int markerId) {
    _markerEventController?.add(MarkerClick(markerId));
  }

  @override
  void onMapClick(Map<String, dynamic> coord) {
    final NLatLng latLng = NLatLng(coord['_lat'], coord['_lng']);
    final NPoint point = NPoint(coord['x'], coord['y']);
    _mapEventController?.add(MapClick(latLng, point));
  }

  @override
  void onMapLongTap(Map<String, dynamic> coord) {
    final NLatLng latLng = NLatLng(coord['_lat'], coord['_lng']);
    final NPoint point = NPoint(coord['x'], coord['y']);
    _mapEventController?.add(MapLongTap(latLng, point));
  }

  @override
  void onMapIdle() {
    _mapEventController?.add(const MapIdle());
  }

  @override
  void onMapZoomChanged(int zoom) {
    _mapEventController?.add(MapZoomChanged(zoom));
  }

  @override
  void onMapZoomEnd() {
    _mapEventController?.add(const MapZoomEnd());
  }

  @override
  void onMapZoomStart() {
    _mapEventController?.add(const MapZoomStart());
  }

  @override
  void onMapCenterChanged(Map<String, dynamic> center) {
    final NLatLng latLng = NLatLng(center['_lat'], center['_lng']);
    final NPoint point = NPoint(center['x'], center['y']);
    _mapEventController?.add(MapCenterChanged(latLng, point));
  }

  @override
  void dispose() async {
    _mapLoadStatusController?.close();
    _markerEventController?.close();
    _mapEventController?.close();
    await disposeMap();
  }

  @override
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

  @override
  Future<int> getZoom() async {
    final num jsonStringResult =
        await _controller.runJavaScriptReturningResult('map.getZoom()') as num;
    return jsonStringResult.toInt();
  }

  @override
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

  @override
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

  @override
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

  @override
  Future<void> setCenter({required Coord center}) async {
    await _controller.runJavaScript('map.setCenter(${center.toJson()})');
  }

  @override
  Future<void> setZoom({required int zoom}) async {
    await _controller.runJavaScript('map.setZoom($zoom)');
  }

  @override
  Future<void> addMarker({
    required String markerId,
    required MarkerOptions markerOptions,
  }) async {
    await _controller.runJavaScript(
      'window.addMarker($markerId, ${markerOptions.toJson()})',
    );
  }

  @override
  Future<void> updateMarker({
    required String markerId,
    required MarkerOptions markerOptions,
  }) async {
    await _controller.runJavaScript(
      'window.updateMarker($markerId, ${markerOptions.toJson()})',
    );
  }

  @override
  Future<void> removeMarker({required String markerId}) async {
    await _controller.runJavaScript('window.removeMarker($markerId)');
  }

  @override
  Future<void> removeMarkerAll() async {
    await _controller.runJavaScript('window.removeMarkerAll()');
  }

  @override
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

  @override
  Future<void> addMarkerClickEvent({required String markerId}) async {
    await _controller.runJavaScript('window.addMarkerClickEvent($markerId)');
  }

  @override
  Future<void> removeMarkerClickEvent({required String markerId}) async {
    await _controller.runJavaScript('window.removeMarkerClickEvent($markerId)');
  }

  @override
  Future<void> addMapClickEventListener() async {
    await _controller.runJavaScript('window.addMapClickEventListener()');
  }

  @override
  Future<void> removeMapClickEventListener() async {
    await _controller.runJavaScript('window.removeMapClickEventListener()');
  }

  @override
  Future<void> addMapLongTapEventListener() async {
    await _controller.runJavaScript('window.addMapLongTapEventListener()');
  }

  @override
  Future<void> removeMapLongTapEventListener() async {
    await _controller.runJavaScript('window.removeMapLongTapEventListener()');
  }

  @override
  Future<void> addMapIdleEventListener() async {
    await _controller.runJavaScript('window.addMapIdleEventListener()');
  }

  @override
  Future<void> removeMapIdleEventListener() async {
    await _controller.runJavaScript('window.removeMapIdleEventListener()');
  }

  @override
  Future<void> addMapZoomChangedEventListener() async {
    await _controller.runJavaScript('window.addMapZoomChangedEventListener()');
  }

  @override
  Future<void> removeMapZoomChangedEventListener() async {
    await _controller.runJavaScript(
      'window.removeMapZoomChangedEventListener()',
    );
  }

  @override
  Future<void> addMapZoomEndEventListener() async {
    await _controller.runJavaScript('window.addMapZoomEndEventListener()');
  }

  @override
  Future<void> removeMapZoomEndEventListener() async {
    await _controller.runJavaScript('window.removeMapZoomEndEventListener()');
  }

  @override
  Future<void> addMapZoomStartEventListener() async {
    await _controller.runJavaScript('window.addMapZoomStartEventListener()');
  }

  @override
  Future<void> removeMapZoomStartEventListener() async {
    await _controller.runJavaScript('window.removeMapZoomStartEventListener()');
  }

  @override
  Future<void> addMapCenterChangedEventListener() async {
    await _controller.runJavaScript(
      'window.addMapCenterChangedEventListener()',
    );
  }

  @override
  Future<void> removeMapCenterChangedEventListener() async {
    await _controller.runJavaScript(
      'window.removeMapCenterChangedEventListener()',
    );
  }

  @override
  Future<void> disposeMap() async {
    await _controller.runJavaScript('window.disposeMap()');
  }
}
