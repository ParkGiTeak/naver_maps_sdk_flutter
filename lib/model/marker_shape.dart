import 'dart:convert';

class MarkerShape {
  final List<int> coords;
  final String type;

  const MarkerShape({
    required this.coords,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'coords': jsonEncode(coords),
      'type': jsonEncode(type),
    };
  }
}
