import 'dart:convert';

import 'package:flutter/foundation.dart';

class MarkerShape {
  final List<int> coords;
  final String type;

  const MarkerShape({required this.coords, required this.type});

  Map<String, dynamic> toJson() {
    return {
      'coords': kIsWeb ? coords : jsonEncode(coords),
      'type': kIsWeb ? type : jsonEncode(type),
    };
  }
}
