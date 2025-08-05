import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naver_maps_sdk_flutter/listener/map_load_status_listener.dart';
import 'package:naver_maps_sdk_flutter/model/map_options.dart';
import 'package:naver_maps_sdk_flutter/naver_maps_sdk_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NaverMapWidget extends StatelessWidget {
  final MapOptions? _mapOptions;
  final MapLoadStatusListener? _listener;
  late final String _applyScriptHtmlContent;

  final WebViewController controller = WebViewController();

  MapLoadStatusListener? get listener => _listener;

  NaverMapWidget({
    super.key,
    MapOptions? mapOptions,
    MapLoadStatusListener? listener,
  }) : _mapOptions = mapOptions,
       _listener = listener;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initNaverScript(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          _initializeWebViewController();
          return WebViewWidget(controller: controller);
        }
      },
    );
  }

  void _initializeWebViewController() {
    controller
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
            _initializeNaverMap(_mapOptions);
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView Error:: $error');
          },
        ),
      )
      ..addJavaScriptChannel(
        'FlutterMethodChannel',
        onMessageReceived: (JavaScriptMessage message) {
          debugPrint('WebView Message:: ${message.message}');
          try {
            final Map<String, dynamic> data = jsonDecode(message.message);
            final String type = data['type'];

            if (type == 'mapLoaded') {
              _listener?.onMapLoadSuccess();
            } else if (type == 'mapLoadFail') {
              _listener?.onMapLoadFail();
            }
          } catch (e) {
            _listener?.onMapLoadFail();
          }
        },
      )
      ..loadHtmlString(
        _applyScriptHtmlContent,
        baseUrl: NaverMapSDK.instance.webServiceUrl,
      );
  }

  Future<void> _initNaverScript() async {
    final String beforeHtmlContent = await rootBundle.loadString(
      'packages/naver_maps_sdk_flutter/assets/naver_map.html',
    );

    final String scriptPlaceHolder =
        '<script id="naverMapScript" type="text/javascript"></script>';
    final String scriptNaverWithClientId =
        '<script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=${NaverMapSDK.instance.clientId}&language=${NaverMapSDK.instance.language.value}"></script>';
    _applyScriptHtmlContent = beforeHtmlContent.replaceFirst(
      scriptPlaceHolder,
      scriptNaverWithClientId,
    );
  }

  Future<void> _initializeNaverMap(MapOptions? mapOptions) async {
    await controller.runJavaScript('initMap(${mapOptions?.toJson() ?? '{}'})');
  }
}
