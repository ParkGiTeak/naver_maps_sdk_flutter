import 'package:naver_maps_sdk_flutter/enum/naver_map_position_type.dart';

abstract class ControlOptions {
  final NaverMapPositionType? position;

  const ControlOptions({this.position});

  Map<String, dynamic> toJson();
}
