import 'package:naver_maps_sdk_flutter/model/point.dart';

class PointBounds {
  Point minPoint;
  Point maxPoint;

  PointBounds(this.minPoint, this.maxPoint);

  @override
  String toString() => 'PointBounds(minPoint: $minPoint, maxPoint: $maxPoint)';

  @override
  int get hashCode => Object.hash(minPoint, maxPoint);

  @override
  bool operator ==(Object other) =>
      other is PointBounds &&
      other.minPoint == minPoint &&
      other.maxPoint == maxPoint;

  PointBounds copyWith({Point? minPoint, Point? maxPoint}) {
    return PointBounds(minPoint ?? this.minPoint, maxPoint ?? this.maxPoint);
  }
}
