class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);

  @override
  String toString() => 'LatLng(latitude: $latitude, longitude: $longitude)';

  @override
  int get hashCode => Object.hash(latitude, longitude);

  @override
  bool operator ==(Object other) =>
      other is LatLng &&
      other.latitude == latitude &&
      other.longitude == longitude;

  LatLng copyWith({double? latitude, double? longitude}) {
    return LatLng(latitude ?? this.latitude, longitude ?? this.longitude);
  }

  LatLng clone() {
    return this;
  }
}
