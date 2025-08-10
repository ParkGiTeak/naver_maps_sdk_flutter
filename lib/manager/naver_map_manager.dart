part of '../naver_maps_sdk_flutter.dart';
class NaverMapManager {
  final WebViewController _controller = WebViewController();

  NaverMapManager._internal();

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
    final List<int> markerIds = jsonDecode(jsonStringResult) as List<int>;
    return markerIds;
  }

  Future<void> addMarkerClickEvent({required int markerId}) async {
    await _controller.runJavaScript('window.addMarkerClickEvent($markerId)');
  }

  Future<void> removeMarkerClickEvent({required int markerId}) async {
    await _controller.runJavaScript('window.removeMarkerClickEvent($markerId)');
  }
}
