import 'package:naver_maps_sdk_flutter/enum/naver_map_language_type.dart';

class NaverMapSDK {
  static NaverMapSDK? _instance;

  NaverMapSDK._internal();

  static NaverMapSDK get instance => _instance ??= NaverMapSDK._internal();

  late final String _clientId;
  late final NaverMapLanguageType _language;
  late final String _webServiceUrl;

  String get clientId => _clientId;

  NaverMapLanguageType get language => _language;

  String get webServiceUrl => _webServiceUrl;

  static void initialize({
    required String clientId,
    required String webServiceUrl,
    NaverMapLanguageType language = NaverMapLanguageType.korean,
  }) {
    instance._clientId = clientId;
    instance._webServiceUrl = webServiceUrl;
    instance._language = language;
  }
}
