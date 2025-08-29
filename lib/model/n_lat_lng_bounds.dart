import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:naver_maps_sdk_flutter/model/bounds.dart';
import 'package:naver_maps_sdk_flutter/model/n_lat_lng.dart';

class NLatLngBounds implements Bounds {
  final NLatLng southWest;
  final NLatLng northEast;

  const NLatLngBounds({required this.southWest, required this.northEast});

  factory NLatLngBounds.fromJson(Map<String, dynamic> json) {
    return NLatLngBounds(
      southWest: NLatLng.fromJson(json['southWest'] ?? {}),
      northEast: NLatLng.fromJson(json['northEast'] ?? {}),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'southWest': kIsWeb ? southWest.toJson() : jsonEncode(southWest.toJson()),
      'northEast': kIsWeb ? northEast.toJson() : jsonEncode(northEast.toJson()),
    };
  }

  bool contains(NLatLng coord) {
    return coord.lat >= southWest.lat &&
        coord.lat <= northEast.lat &&
        coord.lng >= southWest.lng &&
        coord.lng <= northEast.lng;
  }

  NLatLng get center {
    return NLatLng(
      (southWest.lat + northEast.lat) / 2,
      (southWest.lng + northEast.lng) / 2,
    );
  }

  @override
  String toString() =>
      'NLatLngBounds(southWest: $southWest, northEast: $northEast)';
}
