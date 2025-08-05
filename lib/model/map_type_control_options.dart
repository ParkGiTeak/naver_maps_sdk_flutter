import 'package:naver_maps_sdk_flutter/enum/naver_map_map_type_id.dart';
import 'package:naver_maps_sdk_flutter/enum/naver_map_type_control_style.dart';
import 'package:naver_maps_sdk_flutter/model/control_options.dart';

class MapTypeControlOptions extends ControlOptions {
  final List<NaverMapMapTypeId>? mapTypeIds;
  final NaverMapTypeControlStyle? style;

  const MapTypeControlOptions({super.position, this.mapTypeIds, this.style});

  @override
  Map<String, dynamic> toJson() {
    return {
      if (position != null) 'position': position!.value,
      if (mapTypeIds != null) 'mapTypeIds': mapTypeIds!.map((e) => e.value).toList(),
      if (style != null) 'style': style!.value,
    };
  }
}
