import 'dart:convert';

import 'package:naver_maps_sdk_flutter/enum/n_stroke_style.dart';
import 'package:naver_maps_sdk_flutter/enum/symbol_style.dart';
import 'package:naver_maps_sdk_flutter/model/n_icon.dart';
import 'package:naver_maps_sdk_flutter/model/n_point.dart';

class SymbolIcon implements NIcon {
  final List<NPoint> path;

  final SymbolStyle? style;

  final int? radius;

  final String? fillColor;

  final int? fillOpacity;

  final String? strokeColor;

  final NStrokeStyle? strokeStyle;

  final int? strokeWeight;

  final int? strokeOpacity;

  final NPoint? anchor;

  const SymbolIcon({
    required this.path,
    this.style,
    this.radius,
    this.fillColor,
    this.fillOpacity,
    this.strokeColor,
    this.strokeStyle,
    this.strokeWeight,
    this.strokeOpacity,
    this.anchor,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'path': path.map((p) => p.toJson()).toList(),
      if (style != null) 'style': style!.value,
      if (radius != null) 'radius': jsonEncode(radius),
      if (fillColor != null) 'fillColor': jsonEncode(fillColor),
      if (fillOpacity != null) 'fillOpacity': jsonEncode(fillOpacity),
      if (strokeColor != null) 'strokeColor': jsonEncode(strokeColor),
      if (strokeStyle != null) 'strokeStyle': strokeStyle!.value,
      if (strokeWeight != null) 'strokeWeight': jsonEncode(strokeWeight),
      if (strokeOpacity != null) 'strokeOpacity': jsonEncode(strokeOpacity),
      if (anchor != null) 'anchor': anchor!.toJson(),
    };
  }
}
