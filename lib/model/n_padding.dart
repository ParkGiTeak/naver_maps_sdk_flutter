import 'dart:convert';

class NPadding {
  final double top;
  final double right;
  final double bottom;
  final double left;

  const NPadding({
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
    this.left = 0,
  });

  const NPadding.all(double value)
    : top = value,
      right = value,
      bottom = value,
      left = value;

  factory NPadding.fromJson(Map<String, dynamic> json) {
    return NPadding(
      top: json['top']?.toDouble() ?? 0.0,
      right: json['right']?.toDouble() ?? 0.0,
      bottom: json['bottom']?.toDouble() ?? 0.0,
      left: json['left']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'top': jsonEncode(top),
      'right': jsonEncode(right),
      'bottom': jsonEncode(bottom),
      'left': jsonEncode(left),
    };
  }

  @override
  String toString() =>
      'NPadding(top: $top, right: $right, bottom: $bottom, left: $left)';
}
