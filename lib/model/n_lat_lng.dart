import 'package:naver_maps_sdk_flutter/model/coord.dart';

class NLatLng implements Coord {
  final double lat;
  final double lng;

  const NLatLng(this.lat, this.lng);

  factory NLatLng.fromJson(Map<String, dynamic> json) {
    return NLatLng(
      json['lat']?.toDouble() ?? 0.0,
      json['lng']?.toDouble() ?? 0.0,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'lat': lat, 'lng': lng};
  }

  @override
  String toString() => '(lat:$lat,lng:$lng)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NLatLng &&
          runtimeType == other.runtimeType &&
          lat == other.lat &&
          lng == other.lng;

  @override
  int get hashCode => lat.hashCode ^ lng.hashCode;
}
