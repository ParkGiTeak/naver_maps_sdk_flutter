import 'dart:convert';

import 'package:naver_maps_sdk_flutter/model/coord.dart';
import 'package:naver_maps_sdk_flutter/model/n_lat_lng.dart';
import 'package:naver_maps_sdk_flutter/model/n_point.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NaverMapManager {
  final WebViewController _controller;

  NaverMapManager(WebViewController controller) : _controller = controller;

  Future<Coord> getCenter({required bool resultTypeLatLng}) async {
    final String jsonStringResult =
        await _controller.runJavaScriptReturningResult('map.getCenter()')
            as String;
    final Map<String, dynamic> json = jsonDecode(jsonStringResult);
    if (resultTypeLatLng) {
      final Coord coord = NLatLng(
        json['_lat']?.toDouble() ?? 0.0,
        json['_lng']?.toDouble() ?? 0.0,
      );
      return coord;
    } else {
      final Coord coord = NPoint(
        json['x']?.toDouble() ?? 0.0,
        json['y']?.toDouble() ?? 0.0,
      );
      return coord;
    }
  }

  Future<int> getZoom() async {
    final int jsonStringResult =
        await _controller.runJavaScriptReturningResult('map.getZoom()') as int;
    return jsonStringResult;
  }

  Future<void> setCenter({required Coord center}) async {
    await _controller.runJavaScriptReturningResult(
      'map.setCenter(${center.toJson()})',
    );
  }

  Future<void> setZoom({required int zoom}) async {
    await _controller.runJavaScriptReturningResult('map.setZoom($zoom)');
  }
}
