import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:naver_maps_sdk_flutter/model/control_options.dart';

class ScaleControlOptions extends ControlOptions {
  const ScaleControlOptions({super.position});

  @override
  Map<String, dynamic> toJson() {
    return {
      if (position != null)
        'position': kIsWeb ? position!.value : jsonEncode(position!.value),
    };
  }
}
