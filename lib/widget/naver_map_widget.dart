part of '../naver_maps_sdk_flutter.dart';

class NaverMapWidget extends StatelessWidget {
  final MapOptions? _mapOptions;

  final MapLoadStatusListener _mapLoadStatusListener;
  final MarkerEventListener _markerEventListener;

  final NaverMapManager naverMapManager;

  MapLoadStatusListener? get listener => _mapLoadStatusListener;

  const NaverMapWidget({
    super.key,
    required this.naverMapManager,
    MapOptions? mapOptions,
    required MapLoadStatusListener mapLoadStatusListener,
    required MarkerEventListener markerEventListener,
  }) : _mapOptions = mapOptions,
       _mapLoadStatusListener = mapLoadStatusListener,
       _markerEventListener = markerEventListener;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initNaverScript(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          _initializeWebViewController();
          return WebViewWidget(controller: naverMapManager._controller);
        }
      },
    );
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
              _mapLoadStatusListener.onMapLoadSuccess();
            } else if (type == 'mapLoadFail') {
              _mapLoadStatusListener.onMapLoadFail();
            }
          } catch (e) {
            _mapLoadStatusListener.onMapLoadFail();
          }
        },
      )
      ..addJavaScriptChannel(
        'MarkerEvent',
        onMessageReceived: (JavaScriptMessage message) {
          final Map<String, dynamic> json = jsonDecode(message.message);
          if (json['type'] == 'markerClick') {
            _markerEventListener.onMarkerClick(json['markerId']);
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
