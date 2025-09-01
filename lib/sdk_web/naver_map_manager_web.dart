part of 'naver_maps_sdk_flutter_web.dart';

class NaverMapManager implements NaverMapManagerInterface {
  static const String _sdkScriptId = 'naver-maps-sdk-script';
  static web.Document? _htmlDoc;
  static Completer<void>? _htmlDocCompleter;
  static Completer<void>? _sdkCompleter;
  static Completer<void>? _functionsCompleter;

  late final String _mapDivId;
  late final String _mapId;

  Future<web.HTMLDivElement>? _prepareMapFuture;
  bool isViewFactoryRegistered = false;

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

  NaverMapManager._internal() {
    _mapId = 'naver-map-$hashCode';
    _mapDivId = 'naver-map-div-$hashCode';
    _prepareMapFuture = _prepareMap();
    _setupMessageListener();
  }

  static NaverMapManager createNaverMapManager() {
    return NaverMapManager._internal();
  }

  void _setupMessageListener() {
    final mapLoadStatusChannelName = 'MapLoadStatus_$_mapId';
    final mapEventChannelName = 'MapEvent_$_mapId';
    final markerEventChannelName = 'MarkerEvent_$_mapId';

    final mapLoadStatusChannel = {
      'postMessage': (String message) {
        try {
          final decodedMessage = jsonDecode(message) as Map<String, dynamic>;
          final String type = decodedMessage['type'];
          if (type == 'mapLoaded') {
            onMapLoadSuccess();
          } else {
            onMapLoadFail();
          }
        } catch (e) {
          debugPrint('Error decoding message from JS: $e');
        }
      }.toJS,
    }.jsify();
    final mapEventChannel = {
      'postMessage': (String message) {
        try {
          final decodedMessage = jsonDecode(message) as Map<String, dynamic>;
          final String type = decodedMessage['type'];
          switch (type) {
            case 'click':
              onMapClick(decodedMessage['coord']);
              break;
            case 'longtap':
              onMapLongTap(decodedMessage['coord']);
              break;
            case 'idle':
              onMapIdle();
              break;
            case 'zoom_changed':
              onMapZoomChanged(decodedMessage['zoom']);
              break;
            case 'zoomend':
              onMapZoomEnd();
              break;
            case 'zoomstart':
              onMapZoomStart();
              break;
            case 'center_changed':
              onMapCenterChanged(decodedMessage['center']);
              break;
            default:
              throw Exception('Unknown message type: $type');
          }
        } catch (e) {
          debugPrint('Error decoding message from JS: $e');
        }
      }.toJS,
    }.jsify();
    final markerEventChannel = {
      'postMessage': (String message) {
        try {
          final decodedMessage = jsonDecode(message) as Map<String, dynamic>;
          final String type = decodedMessage['type'];
          if (type == 'markerClick') {
            onMarkerClick(decodedMessage['markerId']);
          }
        } catch (e) {
          debugPrint('Error decoding message from JS: $e');
        }
      }.toJS,
    }.jsify();

    globalContext.setProperty(
      mapLoadStatusChannelName.toJS,
      mapLoadStatusChannel,
    );
    globalContext.setProperty(mapEventChannelName.toJS, mapEventChannel);
    globalContext.setProperty(markerEventChannelName.toJS, markerEventChannel);
  }

  Future<web.HTMLDivElement> _prepareMap() async {
    await Future.wait([_loadSdkScript(), _loadHtmlDocument()]);
    await _loadMapFunctionsScript();

    final web.HTMLDivElement mapDiv =
        _htmlDoc?.getElementById('map') as web.HTMLDivElement? ??
              (web.document.createElement('div') as web.HTMLDivElement)
          ..style.width = '100%'
          ..style.height = '100%';
    mapDiv.id = _mapDivId;
    return mapDiv;
  }

  Future<void> _loadHtmlDocument() async {
    if (_htmlDocCompleter != null) {
      return _htmlDocCompleter!.future;
    }
    _htmlDocCompleter = Completer<void>();

    try {
      final htmlContent = await rootBundle.loadString(
        'packages/naver_maps_sdk_flutter/assets/naver_map.html',
      );
      final parser = web.DOMParser();
      _htmlDoc = parser.parseFromString(htmlContent.toJS, 'text/html');
      _htmlDocCompleter!.complete();
    } catch (e) {
      _htmlDocCompleter!.completeError(e);
    }

    return _htmlDocCompleter!.future;
  }

  Future<void> _loadMapFunctionsScript() async {
    if (_functionsCompleter != null) {
      return _functionsCompleter!.future;
    }
    _functionsCompleter = Completer<void>();

    web.document.addEventListener(
      'naverMapFunctionsReady',
      (web.Event event) {
        if (_functionsCompleter?.isCompleted == false) {
          _functionsCompleter?.complete();
        }
      }.toJS,
    );

    try {
      final scriptElement =
          _htmlDoc?.getElementById('naverMapFunctions')
              as web.HTMLScriptElement?;

      if (scriptElement != null) {
        final newScript =
            web.document.createElement('script') as web.HTMLScriptElement;
        newScript.id = 'naverMapFunctions';
        newScript.type = 'text/javascript';
        newScript.text = scriptElement.text;
        web.document.body?.append(newScript);
        web.document.dispatchEvent(web.CustomEvent('naverMapFunctionsReady'));
      } else {
        _functionsCompleter!.completeError(
          Exception('naverMapFunctions script tag not found'),
        );
      }
    } catch (e) {
      _functionsCompleter ??= Completer<void>();
      _functionsCompleter!.completeError(e);
    }

    return _functionsCompleter!.future;
  }

  Future<void> _loadSdkScript() {
    if (_sdkCompleter != null) {
      return _sdkCompleter!.future;
    }
    _sdkCompleter = Completer<void>();

    final script =
        web.document.createElement('script') as web.HTMLScriptElement;
    script.id = _sdkScriptId;
    script.type = 'text/javascript';
    script.src =
        'https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=${NaverMapSDK.instance.clientId}&language=${NaverMapSDK.instance.language.value}';

    script.onload = (web.Event event) {
      if (_sdkCompleter?.isCompleted == false) {
        _sdkCompleter!.complete();
      }
    }.toJS;

    script.onerror = (web.Event event) {
      if (_sdkCompleter?.isCompleted == false) {
        _sdkCompleter!.completeError(Exception('Naver Maps SDK 로드 실패'));
      }
    }.toJS;

    web.document.head?.append(script);

    return _sdkCompleter!.future;
  }

  Future<void> _initializeNaverMap(MapOptions? mapOptions) async {
    const String functionName = 'initMap';
    if (web.window.hasProperty(functionName.toJS).isDefinedAndNotNull) {
      final JSFunction func = web.window.getProperty(functionName.toJS);
      func.callAsFunction(
        web.window,
        _mapDivId.toJS,
        mapOptions?.toJson().jsify(),
        _mapId.toJS,
      );
    } else {
      return Future.error(
        Exception('$functionName is not defined in the window object.'),
      );
    }
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
  Future<Coord> getCenter({required bool shouldReturnLatLng}) async {
    const String functionName = 'getCenter';
    if (web.window.hasProperty(functionName.toJS).isDefinedAndNotNull) {
      final JSFunction func = web.window.getProperty(functionName.toJS);
      final JSAny? result = func.callAsFunction(web.window, _mapId.toJS);
      if (result != null && result.isA<JSObject>()) {
        final JSObject centerJsObj = result as JSObject;
        if (shouldReturnLatLng) {
          final double lat =
              (centerJsObj.getProperty('_lat'.toJS) as JSNumber).toDartDouble;
          final double lng =
              (centerJsObj.getProperty('_lng'.toJS) as JSNumber).toDartDouble;
          final NLatLng latLng = NLatLng(lat, lng);
          return latLng;
        } else {
          final double x =
              (centerJsObj.getProperty('x'.toJS) as JSNumber).toDartDouble;
          final double y =
              (centerJsObj.getProperty('y'.toJS) as JSNumber).toDartDouble;
          final NPoint point = NPoint(x, y);
          return point;
        }
      }
      return Future.error(Exception('$functionName unKnown error occurred.'));
    } else {
      return Future.error(
        Exception('$functionName is not defined in the window object.'),
      );
    }
  }

  @override
  Future<int> getZoom() async {
    const String functionName = 'getZoom';
    if (web.window.hasProperty(functionName.toJS).isDefinedAndNotNull) {
      final JSFunction func = web.window.getProperty(functionName.toJS);
      final JSAny? result = func.callAsFunction(web.window, _mapId.toJS);
      if (result != null && result.isA<JSNumber>()) {
        final int zoom = (result as JSNumber).toDartInt;
        return zoom;
      }
      return Future.error(Exception('$functionName unKnown error occurred.'));
    } else {
      return Future.error(
        Exception('$functionName is not defined in the window object.'),
      );
    }
  }

  @override
  Future<Bounds> getBounds({required bool shouldReturnLatLng}) async {
    const String functionName = 'getBounds';
    if (web.window.hasProperty(functionName.toJS).isDefinedAndNotNull) {
      final JSFunction func = web.window.getProperty(functionName.toJS);
      final JSAny? result = func.callAsFunction(web.window, _mapId.toJS);

      if (result != null && result.isA<JSObject>()) {
        final JSObject boundsJsObj = result as JSObject;
        final Bounds bounds;

        if (shouldReturnLatLng) {
          final JSObject swObj =
              boundsJsObj.getProperty('_sw'.toJS) as JSObject;
          final JSObject neObj =
              boundsJsObj.getProperty('_ne'.toJS) as JSObject;
          final NLatLng sw = NLatLng(
            (swObj.getProperty('_lat'.toJS) as JSNumber).toDartDouble,
            (swObj.getProperty('_lng'.toJS) as JSNumber).toDartDouble,
          );
          final NLatLng ne = NLatLng(
            (neObj.getProperty('_lat'.toJS) as JSNumber).toDartDouble,
            (neObj.getProperty('_lng'.toJS) as JSNumber).toDartDouble,
          );
          bounds = NLatLngBounds(southWest: sw, northEast: ne);
        } else {
          final JSObject minObj =
              boundsJsObj.getProperty('_min'.toJS) as JSObject;
          final JSObject maxObj =
              boundsJsObj.getProperty('_max'.toJS) as JSObject;
          final NPoint min = NPoint(
            (minObj.getProperty('x'.toJS) as JSNumber).toDartDouble,
            (minObj.getProperty('y'.toJS) as JSNumber).toDartDouble,
          );
          final NPoint max = NPoint(
            (maxObj.getProperty('x'.toJS) as JSNumber).toDartDouble,
            (maxObj.getProperty('y'.toJS) as JSNumber).toDartDouble,
          );
          bounds = NPointBounds(min: min, max: max);
        }
        return bounds;
      }
      return Future.error(Exception('$functionName unKnown error occurred.'));
    } else {
      return Future.error(
        Exception('$functionName is not defined in the window object.'),
      );
    }
  }

  @override
  Future<bool> hasLatLng({
    required NLatLngBounds bounds,
    required Coord coord,
  }) async {
    const String functionName = 'hasLatLng';
    if (web.window.hasProperty(functionName.toJS).isDefinedAndNotNull) {
      final JSFunction func = web.window.getProperty(functionName.toJS);
      final JSAny? result = func.callAsFunction(
        web.window,
        bounds.toJson().jsify(),
        coord.toJson().jsify(),
      );
      if (result != null && result.isA<JSBoolean>()) {
        return (result as JSBoolean).toDart;
      }
      return Future.error(Exception('$functionName unKnown error occurred.'));
    } else {
      return Future.error(
        Exception('$functionName is not defined in the window object.'),
      );
    }
  }

  @override
  Future<bool> hasPoint({
    required NPointBounds bounds,
    required Coord coord,
  }) async {
    const String functionName = 'hasPoint';
    if (web.window.hasProperty(functionName.toJS).isDefinedAndNotNull) {
      final JSFunction func = web.window.getProperty(functionName.toJS);
      final JSAny? result = func.callAsFunction(
        web.window,
        bounds.toJson().jsify(),
        coord.toJson().jsify(),
      );
      if (result != null && result.isA<JSBoolean>()) {
        return (result as JSBoolean).toDart;
      }
      return Future.error(Exception('$functionName unKnown error occurred.'));
    } else {
      return Future.error(
        Exception('$functionName is not defined in the window object.'),
      );
    }
  }

  @override
  Future<void> setCenter({required Coord center}) async {
    const String functionName = 'setCenter';
    if (web.window.hasProperty(functionName.toJS).isDefinedAndNotNull) {
      final JSFunction func = web.window.getProperty(functionName.toJS);
      func.callAsFunction(web.window, _mapId.toJS, center.toJson().jsify());
    } else {
      return Future.error(
        Exception('$functionName is not defined in the window object.'),
      );
    }
  }

  @override
  Future<void> setZoom({required int zoom}) async {
    const String functionName = 'setZoom';
    if (web.window.hasProperty(functionName.toJS).isDefinedAndNotNull) {
      final JSFunction func = web.window.getProperty(functionName.toJS);
      func.callAsFunction(web.window, _mapId.toJS, zoom.toJS);
    } else {
      return Future.error(
        Exception('$functionName is not defined in the window object.'),
      );
    }
  }

  @override
  Future<void> addMarker({
    required String markerId,
    required MarkerOptions markerOptions,
  }) async {
    const String functionName = 'addMarker';
    if (web.window.hasProperty(functionName.toJS).isDefinedAndNotNull) {
      final JSFunction func = web.window.getProperty(functionName.toJS);
      func.callAsFunction(
        web.window,
        _mapId.toJS,
        markerId.toJS,
        markerOptions.toJson().jsify(),
      );
    } else {
      return Future.error(
        Exception('$functionName is not defined in the window object.'),
      );
    }
  }

  @override
  Future<void> updateMarker({
    required String markerId,
    required MarkerOptions markerOptions,
  }) async {
    const String functionName = 'updateMarker';
    if (web.window.hasProperty(functionName.toJS).isDefinedAndNotNull) {
      final JSFunction func = web.window.getProperty(functionName.toJS);
      func.callAsFunction(
        web.window,
        _mapId.toJS,
        markerId.toJS,
        markerOptions.toJson().jsify(),
      );
    } else {
      return Future.error(
        Exception('$functionName is not defined in the window object.'),
      );
    }
  }

  @override
  Future<void> removeMarker({required String markerId}) async {
    const String functionName = 'removeMarker';
    if (web.window.hasProperty(functionName.toJS).isDefinedAndNotNull) {
      final JSFunction func = web.window.getProperty(functionName.toJS);
      func.callAsFunction(web.window, _mapId.toJS, markerId.toJS);
    } else {
      return Future.error(
        Exception('$functionName is not defined in the window object.'),
      );
    }
  }

  @override
  Future<void> removeMarkerAll() async {
    const String functionName = 'removeMarkerAll';
    if (web.window.hasProperty(functionName.toJS).isDefinedAndNotNull) {
      final JSFunction func = web.window.getProperty(functionName.toJS);
      func.callAsFunction(web.window, _mapId.toJS);
    } else {
      return Future.error(
        Exception('$functionName is not defined in the window object.'),
      );
    }
  }

  @override
  Future<List<int>> getMarkerIds() async {
    const String functionName = 'getMarkerIds';
    if (web.window.hasProperty(functionName.toJS).isDefinedAndNotNull) {
      final JSFunction func = web.window.getProperty(functionName.toJS);
      final JSAny? result = func.callAsFunction(web.window, _mapId.toJS);
      if (result != null && result.isA<JSArray>()) {
        final JSArray markerIdsJsArray = result as JSArray;
        return markerIdsJsArray.toDart
            .map((e) => int.parse((e as JSString).toDart))
            .toList();
      }
      return Future.error(Exception('$functionName unKnown error occurred.'));
    } else {
      return Future.error(
        Exception('$functionName is not defined in the window object.'),
      );
    }
  }

  @override
  Future<void> addMarkerClickEvent({required String markerId}) async {
    const String functionName = 'addMarkerClickEvent';
    if (web.window.hasProperty(functionName.toJS).isDefinedAndNotNull) {
      final JSFunction func = web.window.getProperty(functionName.toJS);
      func.callAsFunction(web.window, _mapId.toJS, markerId.toJS);
    } else {
      return Future.error(
        Exception('$functionName is not defined in the window object.'),
      );
    }
  }

  @override
  Future<void> removeMarkerClickEvent({required String markerId}) async {
    const String functionName = 'removeMarkerClickEvent';
    if (web.window.hasProperty(functionName.toJS).isDefinedAndNotNull) {
      final JSFunction func = web.window.getProperty(functionName.toJS);
      func.callAsFunction(web.window, _mapId.toJS, markerId.toJS);
    } else {
      return Future.error(
        Exception('$functionName is not defined in the window object.'),
      );
    }
  }

  @override
  Future<void> addMapClickEventListener() async {
    const String functionName = 'addMapClickEventListener';
    if (web.window.hasProperty(functionName.toJS).isDefinedAndNotNull) {
      final JSFunction func = web.window.getProperty(functionName.toJS);
      func.callAsFunction(web.window, _mapId.toJS);
    } else {
      return Future.error(
        Exception('$functionName is not defined in the window object.'),
      );
    }
  }

  @override
  Future<void> removeMapClickEventListener() async {
    const String functionName = 'removeMapClickEventListener';
    if (web.window.hasProperty(functionName.toJS).isDefinedAndNotNull) {
      final JSFunction func = web.window.getProperty(functionName.toJS);
      func.callAsFunction(web.window, _mapId.toJS);
    } else {
      return Future.error(
        Exception('$functionName is not defined in the window object.'),
      );
    }
  }

  @override
  Future<void> addMapLongTapEventListener() async {
    const String functionName = 'addMapLongTapEventListener';
    if (web.window.hasProperty(functionName.toJS).isDefinedAndNotNull) {
      final JSFunction func = web.window.getProperty(functionName.toJS);
      func.callAsFunction(web.window, _mapId.toJS);
    } else {
      return Future.error(
        Exception('$functionName is not defined in the window object.'),
      );
    }
  }

  @override
  Future<void> removeMapLongTapEventListener() async {
    const String functionName = 'removeMapLongTapEventListener';
    if (web.window.hasProperty(functionName.toJS).isDefinedAndNotNull) {
      final JSFunction func = web.window.getProperty(functionName.toJS);
      func.callAsFunction(web.window, _mapId.toJS);
    } else {
      return Future.error(
        Exception('$functionName is not defined in the window object.'),
      );
    }
  }

  @override
  Future<void> addMapIdleEventListener() async {
    const String functionName = 'addMapIdleEventListener';
    if (web.window.hasProperty(functionName.toJS).isDefinedAndNotNull) {
      final JSFunction func = web.window.getProperty(functionName.toJS);
      func.callAsFunction(web.window, _mapId.toJS);
    } else {
      return Future.error(
        Exception('$functionName is not defined in the window object.'),
      );
    }
  }

  @override
  Future<void> removeMapIdleEventListener() async {
    const String functionName = 'removeMapIdleEventListener';
    if (web.window.hasProperty(functionName.toJS).isDefinedAndNotNull) {
      final JSFunction func = web.window.getProperty(functionName.toJS);
      func.callAsFunction(web.window, _mapId.toJS);
    } else {
      return Future.error(
        Exception('$functionName is not defined in the window object.'),
      );
    }
  }

  @override
  Future<void> addMapZoomChangedEventListener() async {
    const String functionName = 'addMapZoomChangedEventListener';
    if (web.window.hasProperty(functionName.toJS).isDefinedAndNotNull) {
      final JSFunction func = web.window.getProperty(functionName.toJS);
      func.callAsFunction(web.window, _mapId.toJS);
    } else {
      return Future.error(
        Exception('$functionName is not defined in the window object.'),
      );
    }
  }

  @override
  Future<void> removeMapZoomChangedEventListener() async {
    const String functionName = 'removeMapZoomChangedEventListener';
    if (web.window.hasProperty(functionName.toJS).isDefinedAndNotNull) {
      final JSFunction func = web.window.getProperty(functionName.toJS);
      func.callAsFunction(web.window, _mapId.toJS);
    } else {
      return Future.error(
        Exception('$functionName is not defined in the window object.'),
      );
    }
  }

  @override
  Future<void> addMapZoomEndEventListener() async {
    const String functionName = 'addMapZoomEndEventListener';
    if (web.window.hasProperty(functionName.toJS).isDefinedAndNotNull) {
      final JSFunction func = web.window.getProperty(functionName.toJS);
      func.callAsFunction(web.window, _mapId.toJS);
    } else {
      return Future.error(
        Exception('$functionName is not defined in the window object.'),
      );
    }
  }

  @override
  Future<void> removeMapZoomEndEventListener() async {
    const String functionName = 'removeMapZoomEndEventListener';
    if (web.window.hasProperty(functionName.toJS).isDefinedAndNotNull) {
      final JSFunction func = web.window.getProperty(functionName.toJS);
      func.callAsFunction(web.window, _mapId.toJS);
    } else {
      return Future.error(
        Exception('$functionName is not defined in the window object.'),
      );
    }
  }

  @override
  Future<void> addMapZoomStartEventListener() async {
    const String functionName = 'addMapZoomStartEventListener';
    if (web.window.hasProperty(functionName.toJS).isDefinedAndNotNull) {
      final JSFunction func = web.window.getProperty(functionName.toJS);
      func.callAsFunction(web.window, _mapId.toJS);
    } else {
      return Future.error(
        Exception('$functionName is not defined in the window object.'),
      );
    }
  }

  @override
  Future<void> removeMapZoomStartEventListener() async {
    const String functionName = 'removeMapZoomStartEventListener';
    if (web.window.hasProperty(functionName.toJS).isDefinedAndNotNull) {
      final JSFunction func = web.window.getProperty(functionName.toJS);
      func.callAsFunction(web.window, _mapId.toJS);
    } else {
      return Future.error(
        Exception('$functionName is not defined in the window object.'),
      );
    }
  }

  @override
  Future<void> addMapCenterChangedEventListener() async {
    const String functionName = 'addMapCenterChangedEventListener';
    if (web.window.hasProperty(functionName.toJS).isDefinedAndNotNull) {
      final JSFunction func = web.window.getProperty(functionName.toJS);
      func.callAsFunction(web.window, _mapId.toJS);
    } else {
      return Future.error(
        Exception('$functionName is not defined in the window object.'),
      );
    }
  }

  @override
  Future<void> removeMapCenterChangedEventListener() async {
    const String functionName = 'removeMapCenterChangedEventListener';
    if (web.window.hasProperty(functionName.toJS).isDefinedAndNotNull) {
      final JSFunction func = web.window.getProperty(functionName.toJS);
      func.callAsFunction(web.window, _mapId.toJS);
    } else {
      return Future.error(
        Exception('$functionName is not defined in the window object.'),
      );
    }
  }

  @override
  Future<void> disposeMap() async {
    const String functionName = 'disposeMap';
    if (web.window.hasProperty(functionName.toJS).isDefinedAndNotNull) {
      final JSFunction func = web.window.getProperty(functionName.toJS);
      func.callAsFunction(web.window, _mapId.toJS);
    } else {
      return Future.error(
        Exception('$functionName is not defined in the window object.'),
      );
    }
  }
}
