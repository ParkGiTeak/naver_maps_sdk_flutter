import 'package:flutter/services.dart';
import 'package:naver_maps_sdk_flutter/enum/naver_map_language_type.dart';

class NaverMapSDK {
  static NaverMapSDK? _instance;

  NaverMapSDK._internal();

  static NaverMapSDK get instance => _instance ??= NaverMapSDK._internal();

  bool _isInitialized = false;
  late final String _clientId;
  late final NaverMapLanguageType _language;
  late final String _webServiceUrl;
  late final String _htmlContent;

  bool get isInitialized => _isInitialized;

  String get clientId => _clientId;

  NaverMapLanguageType get language => _language;
  String get webServiceUrl => _webServiceUrl;

  String get htmlContent {
    if (!_isInitialized) {
      throw Exception(
        'NaverMapSDK is not initialized. Call NaverMapSDK.initialize() first.',
      );
    }
    return _htmlContent;
  }

  static Future<void> initialize({
    required String clientId,
    required String webServiceUrl,
    NaverMapLanguageType language = NaverMapLanguageType.korean,
  }) async {
    if (instance.isInitialized) {
      print('NaverMapSDK is already initialized.');
      return;
    }
    instance._clientId = clientId;
    instance._webServiceUrl = webServiceUrl;
    instance._language = language;

    final String beforeHtmlContent = await rootBundle.loadString(
      'packages/naver_maps_sdk_flutter/assets/naver_map.html',
    );

    final String scriptPlaceHolder =
        '<script id="naverMapScript" type="text/javascript"></script>';
    final String scriptNaverWithClientId =
        '<script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=${instance.clientId}&language=${instance.language.value}"></script>';
    instance._htmlContent = beforeHtmlContent.replaceFirst(
      scriptPlaceHolder,
      scriptNaverWithClientId,
    );
    instance._isInitialized = true;
  }
}
