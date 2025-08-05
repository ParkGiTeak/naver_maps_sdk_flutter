class NSize {
  final double width;
  final double height;

  const NSize(this.width, this.height);

  factory NSize.fromJson(Map<String, dynamic> json) {
    return NSize(
      json['width']?.toDouble() ?? 0.0,
      json['height']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'width': width, 'height': height};
  }

  @override
  String toString() => 'NSize($width, $height)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NSize &&
          runtimeType == other.runtimeType &&
          width == other.width &&
          height == other.height;

  @override
  int get hashCode => width.hashCode ^ height.hashCode;
}
