import 'dart:convert';

import 'package:naver_maps_sdk_flutter/model/n_icon.dart';
import 'package:naver_maps_sdk_flutter/model/n_point.dart';
import 'package:naver_maps_sdk_flutter/model/n_size.dart';

class HtmlIcon implements NIcon {
  final String content;

  final NSize? size;

  final NPoint? anchor;

  const HtmlIcon({required this.content, this.size, this.anchor});

  @override
  Map<String, dynamic> toJson() {
    return {
      'content': jsonEncode(content),
      if (size != null) 'size': size!.toJson(),
      if (anchor != null) 'anchor': anchor!.toJson(),
    };
  }
}
