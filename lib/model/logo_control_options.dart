import 'package:naver_maps_sdk_flutter/model/control_options.dart';

class LogoControlOptions extends ControlOptions {
  const LogoControlOptions({super.position});

  @override
  Map<String, dynamic> toJson() {
    return {if (position != null) 'position': position!.value};
  }
}
