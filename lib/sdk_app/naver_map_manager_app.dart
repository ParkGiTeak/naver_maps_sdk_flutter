part of 'naver_maps_sdk_flutter_app.dart';

class NaverMapManager implements NaverMapManagerInterface {
  final WebViewController _controller = WebViewController();
  final Completer<void> _pageFinishedCompleter = Completer<void>();

  late final String _mapDivId;
  late final String _mapId;

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

  Future<void> get onPageFinished => _pageFinishedCompleter.future;

  NaverMapManager._internal() {
    _mapId = 'naver-map-$hashCode';
    _mapDivId = 'naver-map-div-$hashCode';
    _initializeWebViewController();
  }

  static NaverMapManager createNaverMapManager() {
    return NaverMapManager._internal();
  }

  void _initializeWebViewController() async {
    _controller
      ..setOnConsoleMessage((message) {
        debugPrint('WebView Console:: ${message.message}');
      })
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is Loading Progress:: $progress');
          },
          onPageStarted: (String url) {
            debugPrint('WebView Page Started:: $url');
          },
          onPageFinished: (String url) {
            debugPrint('WebView Page Finished:: $url');
            if (!_pageFinishedCompleter.isCompleted) {
              _pageFinishedCompleter.complete();
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView Error:: ${error.description}');
          },
        ),
      )
      ..addJavaScriptChannel(
        'MapLoadStatus_$_mapId',
        onMessageReceived: (JavaScriptMessage message) {
          debugPrint('WebView Message:: ${message.message}');
          try {
            final Map<String, dynamic> data = jsonDecode(message.message);
            final String type = data['type'];

            if (type == 'mapLoaded') {
              onMapLoadSuccess();
            } else if (type == 'mapLoadFail') {
              onMapLoadFail();
            }
          } catch (e) {
            onMapLoadFail();
          }
        },
      )
      ..addJavaScriptChannel(
        'MapEvent_$_mapId',
        onMessageReceived: (JavaScriptMessage message) {
          final Map<String, dynamic> json = jsonDecode(message.message);
          final String type = json['type'];
          switch (type) {
            case 'click':
              onMapClick(json['coord']);
              break;
            case 'longtap':
              onMapLongTap(json['coord']);
              break;
            case 'idle':
              onMapIdle();
              break;
            case 'zoom_changed':
              onMapZoomChanged(json['zoom']);
              break;
            case 'zoomend':
              onMapZoomEnd();
              break;
            case 'zoomstart':
              onMapZoomStart();
              break;
            case 'center_changed':
              onMapCenterChanged(json['center']);
              break;
          }
        },
      )
      ..addJavaScriptChannel(
        'MarkerEvent_$_mapId',
        onMessageReceived: (JavaScriptMessage message) {
          final Map<String, dynamic> json = jsonDecode(message.message);
          if (json['type'] == 'markerClick') {
            final String markerId = json['markerId'].toString();
            onMarkerClick(markerId);
          }
        },
      )
      ..loadHtmlString(
        await _initNaverScript(),
        baseUrl: NaverMapSDK.instance.webServiceUrl,
      );
  }

  Future<String> _initNaverScript() async {
    final String beforeHtmlContent = await rootBundle.loadString(
      'packages/naver_maps_sdk_flutter/assets/naver_map.html',
    );

    final String scriptPlaceHolder =
        '<script id="naverMapScript" type="text/javascript"></script>';
    final String scriptNaverWithClientId =
        '<script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=${NaverMapSDK.instance.clientId}&language=${NaverMapSDK.instance.language.value}"></script>';
    final String mapDivPlaceHolder = 'id="map"';
    final String mapDivId = 'id="$_mapDivId"';
    return beforeHtmlContent
        .replaceFirst(scriptPlaceHolder, scriptNaverWithClientId)
        .replaceFirst(mapDivPlaceHolder, mapDivId);
  }

  Future<void> _initializeNaverMap(MapOptions? mapOptions) async {
    debugPrint('mapOptions:: ${mapOptions?.toJson() ?? '{}'}');
    await _controller.runJavaScript(
      'initMap(${jsonEncode(_mapDivId)}, ${mapOptions?.toJson() ?? '{}'}, ${jsonEncode(_mapId)})',
    );
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
  void onMarkerClick(String markerId) {
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
  Future<Coord> getCenter({required bool shouldReturnLatLng}) async {
    String jsonStringResult =
        await _controller.runJavaScriptReturningResult(
              'window.getCenter(${jsonEncode(_mapId)})',
            )
            as String;
    if (Platform.isIOS) {
      jsonStringResult = NSDictionaryUtil.convert(jsonStringResult);
    }
    final Map<String, dynamic> json = jsonDecode(jsonStringResult);
    if (shouldReturnLatLng) {
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
        await _controller.runJavaScriptReturningResult(
              'getZoom(${jsonEncode(_mapId)})',
            )
            as num;
    return jsonStringResult.toInt();
  }

  @override
  Future<Bounds> getBounds({required bool shouldReturnLatLng}) async {
    String jsonStringResult =
        await _controller.runJavaScriptReturningResult(
              'getBounds(${jsonEncode(_mapId)})',
            )
            as String;
    if (Platform.isIOS) {
      jsonStringResult = NSDictionaryUtil.convert(jsonStringResult);
    }
    final Map<String, dynamic> json = jsonDecode(jsonStringResult);
    final Bounds bounds;
    if (shouldReturnLatLng) {
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
    await _controller.runJavaScript(
      'window.setCenter(${jsonEncode(_mapId)}, ${center.toJson()})',
    );
  }

  @override
  Future<void> setZoom({required int zoom}) async {
    await _controller.runJavaScript('setZoom(${jsonEncode(_mapId)}, $zoom)');
  }

  @override
  Future<void> addMarker({
    required String markerId,
    required MarkerOptions markerOptions,
  }) async {
    await _controller.runJavaScript(
      'window.addMarker(${jsonEncode(_mapId)}, ${jsonEncode(markerId)}, ${markerOptions.toJson()})',
    );
  }

  @override
  Future<void> updateMarker({
    required String markerId,
    required MarkerOptions markerOptions,
  }) async {
    await _controller.runJavaScript(
      'window.updateMarker(${jsonEncode(_mapId)}, ${jsonEncode(markerId)}, ${markerOptions.toJson()})',
    );
  }

  @override
  Future<void> removeMarker({required String markerId}) async {
    await _controller.runJavaScript(
      'window.removeMarker(${jsonEncode(_mapId)}, ${jsonEncode(markerId)})',
    );
  }

  @override
  Future<void> removeMarkerAll() async {
    await _controller.runJavaScript(
      'window.removeMarkerAll(${jsonEncode(_mapId)})',
    );
  }

  @override
  Future<List<int>> getMarkerIds() async {
    String jsonStringResult =
        await _controller.runJavaScriptReturningResult(
              'window.getMarkerIds(${jsonEncode(_mapId)})',
            )
            as String;
    if (Platform.isIOS) {
      jsonStringResult = NSDictionaryUtil.convert(jsonStringResult);
    }
    final List<dynamic> markerIds = jsonDecode(jsonStringResult);
    return markerIds.cast<int>();
  }

  @override
  Future<void> addMarkerClickEvent({required String markerId}) async {
    await _controller.runJavaScript(
      'window.addMarkerClickEvent(${jsonEncode(_mapId)}, ${jsonEncode(markerId)})',
    );
  }

  @override
  Future<void> removeMarkerClickEvent({required String markerId}) async {
    await _controller.runJavaScript(
      'window.removeMarkerClickEvent(${jsonEncode(_mapId)}, ${jsonEncode(markerId)})',
    );
  }

  @override
  Future<void> addMapClickEventListener() async {
    await _controller.runJavaScript(
      'window.addMapClickEventListener(${jsonEncode(_mapId)})',
    );
  }

  @override
  Future<void> removeMapClickEventListener() async {
    await _controller.runJavaScript(
      'window.removeMapClickEventListener(${jsonEncode(_mapId)})',
    );
  }

  @override
  Future<void> addMapLongTapEventListener() async {
    await _controller.runJavaScript(
      'window.addMapLongTapEventListener(${jsonEncode(_mapId)})',
    );
  }

  @override
  Future<void> removeMapLongTapEventListener() async {
    await _controller.runJavaScript(
      'window.removeMapLongTapEventListener(${jsonEncode(_mapId)})',
    );
  }

  @override
  Future<void> addMapIdleEventListener() async {
    await _controller.runJavaScript(
      'window.addMapIdleEventListener(${jsonEncode(_mapId)})',
    );
  }

  @override
  Future<void> removeMapIdleEventListener() async {
    await _controller.runJavaScript(
      'window.removeMapIdleEventListener(${jsonEncode(_mapId)})',
    );
  }

  @override
  Future<void> addMapZoomChangedEventListener() async {
    await _controller.runJavaScript(
      'window.addMapZoomChangedEventListener(${jsonEncode(_mapId)})',
    );
  }

  @override
  Future<void> removeMapZoomChangedEventListener() async {
    await _controller.runJavaScript(
      'window.removeMapZoomChangedEventListener(${jsonEncode(_mapId)})',
    );
  }

  @override
  Future<void> addMapZoomEndEventListener() async {
    await _controller.runJavaScript(
      'window.addMapZoomEndEventListener(${jsonEncode(_mapId)})',
    );
  }

  @override
  Future<void> removeMapZoomEndEventListener() async {
    await _controller.runJavaScript(
      'window.removeMapZoomEndEventListener(${jsonEncode(_mapId)})',
    );
  }

  @override
  Future<void> addMapZoomStartEventListener() async {
    await _controller.runJavaScript(
      'window.addMapZoomStartEventListener(${jsonEncode(_mapId)})',
    );
  }

  @override
  Future<void> removeMapZoomStartEventListener() async {
    await _controller.runJavaScript(
      'window.removeMapZoomStartEventListener(${jsonEncode(_mapId)})',
    );
  }

  @override
  Future<void> addMapCenterChangedEventListener() async {
    await _controller.runJavaScript(
      'window.addMapCenterChangedEventListener(${jsonEncode(_mapId)})',
    );
  }

  @override
  Future<void> removeMapCenterChangedEventListener() async {
    await _controller.runJavaScript(
      'window.removeMapCenterChangedEventListener(${jsonEncode(_mapId)})',
    );
  }

  @override
  Future<void> disposeMap() async {
    await _controller.runJavaScript('window.disposeMap(${jsonEncode(_mapId)})');
  }
}
