import 'dart:convert';

import 'package:naver_maps_sdk_flutter/enum/n_animation.dart';
import 'package:naver_maps_sdk_flutter/model/coord.dart';
import 'package:naver_maps_sdk_flutter/model/n_image_icon.dart';
import 'package:naver_maps_sdk_flutter/model/marker_shape.dart';
import 'package:naver_maps_sdk_flutter/model/n_size.dart';

class MarkerOptions {
  final NAnimation? animation;
  final Coord position;
  final NImageIcon? icon;
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
      if (title != null) 'title': jsonEncode(title),
      if (cursor != null) 'cursor': jsonEncode(cursor),
      if (clickable != null) 'clickable': jsonEncode(clickable),
      if (draggable != null) 'draggable': jsonEncode(draggable),
      if (visible != null) 'visible': jsonEncode(visible),
      if (zIndex != null) 'zIndex': jsonEncode(zIndex),
      if (collisionBehavior != null) 'collisionBehavior': jsonEncode(collisionBehavior),
      if (collisionBoxSize != null) 'collisionBoxSize': collisionBoxSize!.toJson(),
    };
  }
}