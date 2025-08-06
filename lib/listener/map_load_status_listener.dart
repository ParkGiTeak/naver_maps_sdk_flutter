import 'package:naver_maps_sdk_flutter/manager/naver_map_manager.dart';

abstract interface class MapLoadStatusListener {
  void onMapLoadSuccess(NaverMapManager naverMapManager);
  void onMapLoadFail();
}