import 'lat_lng.dart';

class LatLngBounds {
  final LatLng sw;
  final LatLng ne;

  LatLngBounds(this.sw, this.ne);

  @override
  String toString() => 'LatLngBounds(sw: $sw, ne: $ne)';

  @override
  int get hashCode => Object.hash(sw, ne);

  @override
  bool operator ==(Object other) =>
      other is LatLngBounds && other.sw == sw && other.ne == ne;

  LatLngBounds copyWith({LatLng? sw, LatLng? ne}) {
    return LatLngBounds(sw ?? this.sw, ne ?? this.ne);
  }

  LatLngBounds clone() {
    return this;
  }
}
