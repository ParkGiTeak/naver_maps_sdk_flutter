enum NaverMapMapTypeId {
  normal('NORMAL'),
  terrain('TERRAIN'),
  satellite('SATELLITE'),
  hybrid('HYBRID');

  const NaverMapMapTypeId(this.value);
  final String value;

  static NaverMapMapTypeId fromString(String value) {
    return NaverMapMapTypeId.values.firstWhere(
          (e) => e.value == value,
      orElse: () => NaverMapMapTypeId.normal,
    );
  }
}