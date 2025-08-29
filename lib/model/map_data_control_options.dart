import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:naver_maps_sdk_flutter/model/control_options.dart';

class MapDataControlOptions extends ControlOptions {
  final bool? visible;

  const MapDataControlOptions({super.position, this.visible});

  @override
  Map<String, dynamic> toJson() {
    return {
      if (position != null)
        'position': kIsWeb ? position!.value : jsonEncode(position!.value),
      if (visible != null) 'visible': kIsWeb ? visible : jsonEncode(visible),
    };
  }
}
