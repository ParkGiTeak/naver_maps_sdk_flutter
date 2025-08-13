part of '../naver_maps_sdk_flutter.dart';

class NaverMapWidget extends StatelessWidget {
  final MapOptions? _mapOptions;

  final NaverMapManager naverMapManager;

  const NaverMapWidget({
    super.key,
    required this.naverMapManager,
    MapOptions? mapOptions,
  }) : _mapOptions = mapOptions;

  @override
  Widget build(BuildContext context) {
    _initializeWebViewController();
    return WebViewWidget(controller: naverMapManager._controller);
  }

  void _initializeWebViewController() async {
    naverMapManager._controller
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
            debugPrint('WebView Error:: ${error.description}');
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
              naverMapManager.onMapLoadSuccess();
            } else if (type == 'mapLoadFail') {
              naverMapManager.onMapLoadFail();
            }
          } catch (e) {
            naverMapManager.onMapLoadFail();
          }
        },
      )
      ..addJavaScriptChannel(
        'MarkerEvent',
        onMessageReceived: (JavaScriptMessage message) {
          final Map<String, dynamic> json = jsonDecode(message.message);
          if (json['type'] == 'markerClick') {
            naverMapManager.onMarkerClick(json['markerId']);
          }
        },
      )
      ..addJavaScriptChannel(
        'MapEvent',
        onMessageReceived: (JavaScriptMessage message) {
          final Map<String, dynamic> json = jsonDecode(message.message);
          final String type = json['type'];
          switch (type) {
            case 'click':
              naverMapManager.onMapClick(json['coord']);
              break;
            case 'longtap':
              naverMapManager.onMapLongTap(json['coord']);
              break;
            case 'idle':
              naverMapManager.onMapIdle();
              break;
            case 'zoom_changed':
              naverMapManager.onMapZoomChanged(json['zoom']);
              break;
            case 'zoomend':
              naverMapManager.onMapZoomEnd();
              break;
            case 'zoomstart':
              naverMapManager.onMapZoomStart();
              break;
            case 'center_changed':
              naverMapManager.onMapCenterChanged(json['center']);
              break;
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
    return beforeHtmlContent.replaceFirst(
      scriptPlaceHolder,
      scriptNaverWithClientId,
    );
  }

  Future<void> _initializeNaverMap(MapOptions? mapOptions) async {
    debugPrint('mapOptions:: ${mapOptions?.toJson() ?? '{}'}');
    await naverMapManager._controller.runJavaScript(
      'initMap(${mapOptions?.toJson() ?? '{}'})',
    );
  }
}
