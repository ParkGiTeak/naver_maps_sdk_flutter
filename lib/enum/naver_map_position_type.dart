enum NaverMapPositionType {
  center(0),
  topLeft(1),
  topCenter(2),
  topRight(3),
  leftCenter(4),
  leftTop(5),
  leftBottom(6),
  rightTop(7),
  rightCenter(8),
  rightBottom(9),
  bottomLeft(10),
  bottomCenter(11),
  bottomRight(12);

  const NaverMapPositionType(this.value);

  final int value;
}
