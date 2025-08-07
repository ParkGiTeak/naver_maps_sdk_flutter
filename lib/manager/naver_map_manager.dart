import 'dart:convert';
import 'dart:io';

import 'package:naver_maps_sdk_flutter/model/coord.dart';
import 'package:naver_maps_sdk_flutter/model/n_lat_lng.dart';
import 'package:naver_maps_sdk_flutter/model/n_point.dart';
import 'package:naver_maps_sdk_flutter/util/ns_dictionary_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NaverMapManager {
  final WebViewController _controller;

  NaverMapManager(WebViewController controller) : _controller = controller;

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
}
