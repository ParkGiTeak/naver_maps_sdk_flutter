import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:naver_maps_sdk_flutter/enum/n_animation.dart';
import 'package:naver_maps_sdk_flutter/model/coord.dart';
import 'package:naver_maps_sdk_flutter/model/n_icon.dart';
import 'package:naver_maps_sdk_flutter/model/marker_shape.dart';
import 'package:naver_maps_sdk_flutter/model/n_size.dart';

class MarkerOptions {
  final NAnimation? animation;
  final Coord position;
  final NIcon? icon;
  final MarkerShape? shape;
  final String? title;
  final String? cursor;
  final bool? clickable;
  final bool? draggable;
  final bool? visible;
  final int? zIndex;
  final bool? collisionBehavior;
  final NSize? collisionBoxSize;

  const MarkerOptions({
    this.animation,
    required this.position,
    this.icon,
    this.shape,
    this.title,
    this.cursor,
    this.clickable,
    this.draggable,
    this.visible,
    this.zIndex,
    this.collisionBehavior,
    this.collisionBoxSize,
  });

  Map<String, dynamic> toJson() {
    return {
      if (animation != null) 'animation': animation!.value,
      'position': position.toJson(),
      if (icon != null) 'icon': icon!.toJson(),
      if (shape != null) 'shape': shape!.toJson(),
      if (title != null) 'title': kIsWeb ? title : jsonEncode(title),
      if (cursor != null) 'cursor': kIsWeb ? cursor : jsonEncode(cursor),
      if (clickable != null)
        'clickable': kIsWeb ? clickable : jsonEncode(clickable),
      if (draggable != null)
        'draggable': kIsWeb ? draggable : jsonEncode(draggable),
      if (visible != null) 'visible': kIsWeb ? visible : jsonEncode(visible),
      if (zIndex != null) 'zIndex': kIsWeb ? zIndex : jsonEncode(zIndex),
      if (collisionBehavior != null)
        'collisionBehavior': kIsWeb
            ? collisionBehavior
            : jsonEncode(collisionBehavior),
      if (collisionBoxSize != null)
        'collisionBoxSize': collisionBoxSize!.toJson(),
    };
  }
}
