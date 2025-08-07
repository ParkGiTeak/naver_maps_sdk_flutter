import 'dart:convert';

import 'package:naver_maps_sdk_flutter/model/n_point.dart';
import 'package:naver_maps_sdk_flutter/model/n_size.dart';

class NImageIcon {
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

  Map<String, dynamic> toJson() {
    return {
      'url': jsonEncode(url),
      if (size != null) 'size': size!.toJson(),
      if (scaledSize != null) 'scaledSize': scaledSize!.toJson(),
      if (origin != null) 'origin': origin!.toJson(),
      if (anchor != null) 'anchor': anchor!.toJson(),
    };
  }
}
