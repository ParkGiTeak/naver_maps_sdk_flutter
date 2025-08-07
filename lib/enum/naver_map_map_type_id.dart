enum NaverMapMapTypeId {
  normal('normal'),
  terrain('terrain'),
  satellite('satellite'),
  hybrid('hybrid');

  const NaverMapMapTypeId(this.value);
  final String value;

  static NaverMapMapTypeId fromString(String value) {
    return NaverMapMapTypeId.values.firstWhere(
          (e) => e.value == value,
      orElse: () => NaverMapMapTypeId.normal,
    );
  }
}