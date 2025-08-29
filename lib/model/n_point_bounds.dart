import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:naver_maps_sdk_flutter/model/bounds.dart';
import 'package:naver_maps_sdk_flutter/model/n_point.dart';

class NPointBounds implements Bounds {
  final NPoint min;
  final NPoint max;

  const NPointBounds({required this.min, required this.max});

  factory NPointBounds.fromJson(Map<String, dynamic> json) {
    return NPointBounds(
      min: NPoint.fromJson(json['min'] ?? {}),
      max: NPoint.fromJson(json['max'] ?? {}),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'min': kIsWeb ? min.toJson() : jsonEncode(min.toJson()),
      'max': kIsWeb ? max.toJson() : jsonEncode(max.toJson()),
    };
  }

  @override
  String toString() => 'NPointBounds(min: $min, max: $max)';
}
