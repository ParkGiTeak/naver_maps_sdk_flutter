library;

import 'dart:async';
import 'dart:io';
import 'package:naver_maps_sdk_flutter/enum/naver_map_language_type.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naver_maps_sdk_flutter/model/map_options.dart';
import 'package:naver_maps_sdk_flutter/model/marker_options.dart';
import 'package:naver_maps_sdk_flutter/model/n_lat_lng.dart';
import 'package:naver_maps_sdk_flutter/model/n_point.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'model/coord.dart';
import 'event/map_load_status_event.dart';
import 'event/marker_event.dart';
import 'util/ns_dictionary_util.dart';

part 'widget/naver_map_widget.dart';

part 'manager/naver_map_manager.dart';

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

  static NaverMapManager createNaverMapManager() {
    return NaverMapManager._internal();
  }
}
