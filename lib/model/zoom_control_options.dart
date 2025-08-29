import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:naver_maps_sdk_flutter/enum/naver_map_zoom_control_style.dart';
import 'package:naver_maps_sdk_flutter/model/control_options.dart';

class ZoomControlOptions extends ControlOptions {
  final NaverMapZoomControlStyle? style;
  final bool? legendDisabled;

  const ZoomControlOptions({super.position, this.style, this.legendDisabled});

  @override
  Map<String, dynamic> toJson() {
    return {
      if (position != null)
        'position': kIsWeb ? position!.value : jsonEncode(position!.value),
      if (style != null)
        'style': kIsWeb ? style!.value : jsonEncode(style!.value),
      if (legendDisabled != null)
        'legendDisabled': kIsWeb ? legendDisabled : jsonEncode(legendDisabled),
    };
  }
}
