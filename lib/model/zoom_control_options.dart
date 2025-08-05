import 'package:naver_maps_sdk_flutter/model/control_options.dart';

class ZoomControlOptions extends ControlOptions {
  final String? style;

  const ZoomControlOptions({super.position, this.style});

  @override
  Map<String, dynamic> toJson() {
    return {
      if (position != null) 'position': position!.value,
      if (style != null) 'style': style,
    };
  }
}
