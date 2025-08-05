import 'package:naver_maps_sdk_flutter/model/bounds.dart';
import 'package:naver_maps_sdk_flutter/model/coord.dart';
import 'package:naver_maps_sdk_flutter/model/n_lat_lng.dart';
import 'package:naver_maps_sdk_flutter/model/n_lat_lng_bounds.dart';
import 'package:naver_maps_sdk_flutter/model/n_padding.dart';
import 'package:naver_maps_sdk_flutter/model/n_point.dart';
import 'package:naver_maps_sdk_flutter/model/n_point_bounds.dart';

import '../model/n_size.dart';

class MapOptionsUtils {
  // Coord 타입의 값을 파싱
  static Coord? parseCoord(dynamic value) {
    if (value == null) return null;

    if (value is Coord) {
      return value;
    } else if (value is Map<String, dynamic>) {
      // lat, lng가 있으면 LatLng으로 파싱
      if (value.containsKey('lat') && value.containsKey('lng')) {
        return NLatLng.fromJson(value);
      }
      // x, y가 있으면 Point로 파싱
      else if (value.containsKey('x') && value.containsKey('y')) {
        return NPoint.fromJson(value);
      }
    }
    return null;
  }

  // Bounds 타입의 값을 파싱
  static Bounds? parseBounds(dynamic value) {
    if (value == null) return null;

    if (value is Bounds) {
      return value;
    } else if (value is Map<String, dynamic>) {
      // southWest, northEast가 있으면 LatLngBounds로 파싱
      if (value.containsKey('southWest') && value.containsKey('northEast')) {
        return NLatLngBounds.fromJson(value);
      }
      // min, max가 있으면 PointBounds로 파싱
      else if (value.containsKey('min') && value.containsKey('max')) {
        return NPointBounds.fromJson(value);
      }
    }
    return null;
  }

  // Size 또는 SizeLiteral을 파싱
  static NSize? parseSize(dynamic value) {
    if (value == null) return null;

    if (value is NSize) {
      return value;
    } else if (value is Map<String, dynamic>) {
      return NSize.fromJson(value);
    }
    return null;
  }

  // Padding 또는 PaddingLiteral을 파싱
  static NPadding? parsePadding(dynamic value) {
    if (value == null) return null;

    if (value is NPadding) {
      return value;
    } else if (value is Map<String, dynamic>) {
      return NPadding.fromJson(value);
    }
    return null;
  }
}
