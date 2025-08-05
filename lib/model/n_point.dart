import 'package:naver_maps_sdk_flutter/model/coord.dart';

class NPoint implements Coord {
  final double x;
  final double y;

  const NPoint(this.x, this.y);

  factory NPoint.fromJson(Map<String, dynamic> json) {
    return NPoint(json['x']?.toDouble() ?? 0.0, json['y']?.toDouble() ?? 0.0);
  }

  @override
  Map<String, dynamic> toJson() {
    return {'x': x, 'y': y};
  }

  @override
  String toString() => ' NPoint($x, $y)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NPoint &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}
