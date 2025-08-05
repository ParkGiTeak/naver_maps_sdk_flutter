class Point {
  final double x;
  final double y;

  Point(this.x, this.y);

  @override
  String toString() => 'Point(x: $x, y: $y)';

  @override
  int get hashCode => Object.hash(x, y);

  @override
  bool operator ==(Object other) =>
      other is Point && other.x == x && other.y == y;

  Point copyWith({double? x, double? y}) {
    return Point(x ?? this.x, y ?? this.y);
  }

  Point clone() {
    return this;
  }
}
