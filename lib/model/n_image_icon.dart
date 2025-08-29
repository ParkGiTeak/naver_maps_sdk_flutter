import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:naver_maps_sdk_flutter/model/n_icon.dart';
import 'package:naver_maps_sdk_flutter/model/n_point.dart';
import 'package:naver_maps_sdk_flutter/model/n_size.dart';

class NImageIcon implements NIcon {
  final String url;
  final NSize? size;
  final NSize? scaledSize;
  final NPoint? origin;
  final NPoint? anchor;

  const NImageIcon({
    required this.url,
    this.size,
    this.scaledSize,
    this.origin,
    this.anchor,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'url': kIsWeb ? url : jsonEncode(url),
      if (size != null) 'size': size!.toJson(),
      if (scaledSize != null) 'scaledSize': scaledSize!.toJson(),
      if (origin != null) 'origin': origin!.toJson(),
      if (anchor != null) 'anchor': anchor!.toJson(),
    };
  }
}
