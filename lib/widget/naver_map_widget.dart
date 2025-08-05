import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:naver_maps_sdk_flutter/listener/map_load_status_listener.dart';
import 'package:naver_maps_sdk_flutter/model/lat_lng.dart';
import 'package:naver_maps_sdk_flutter/naver_maps_sdk_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NaverMapWidget extends StatelessWidget {
  final LatLng? _initialLatLng;
  final int? _initialZoom;

  final WebViewController controller = WebViewController();
  final MapLoadStatusListener? _listener;

  MapLoadStatusListener? get listener => _listener;

  NaverMapWidget({
    super.key,
    LatLng? initialLatLng,
    int? initialZoom,
    MapLoadStatusListener? listener,
  }) : _listener = listener,
       _initialLatLng = initialLatLng,
       _initialZoom = initialZoom {
    if (!NaverMapSDK.instance.isInitialized) {
      throw Exception(
        'NaverMapSDK is not initialized. Call NaverMapSDK.initialize() first.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _initializeWebViewController();
    return WebViewWidget(controller: controller);
  }

  void _initializeWebViewController() {
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            print('WebView is Loading Progress:: $progress');
          },
          onPageStarted: (String url) {
            print('WebView Page Started:: $url');
          },
          onPageFinished: (String url) {
            print('WebView Page Finished:: $url');
            _initializeNaverMap(_initialLatLng, _initialZoom);
          },
          onWebResourceError: (WebResourceError error) {
            print('WebView Error:: $error');
          },
        ),
      )
      ..addJavaScriptChannel(
        'FlutterMethodChannel',
        onMessageReceived: (JavaScriptMessage message) {
          print('WebView Message:: ${message.message}');
          try {
            final Map<String, dynamic> data = jsonDecode(message.message);
            final String type = data['type'];

            if (type == 'mapLoaded') {
              print('Naver Map Api Loaded!!');
              _listener?.onMapLoadSuccess();
            } else if (type == 'mapLoadFail') {
              print('Naver Map Api Load Fail!!');
              _listener?.onMapLoadFail();
            }
          } catch (e) {
            print('Error WebView Parsing Message From JS:: $e');
          }
        },
      )
      ..loadHtmlString(NaverMapSDK.instance.htmlContent, baseUrl: NaverMapSDK.instance.webServiceUrl);
  }

  Future<void> _initializeNaverMap(
    LatLng? initialLatLng,
    int? initialZoom,
  ) async {
    await controller.runJavaScript(
      'initMap(${initialLatLng?.latitude}, ${initialLatLng?.longitude}, $initialZoom);',
    );
  }
}
