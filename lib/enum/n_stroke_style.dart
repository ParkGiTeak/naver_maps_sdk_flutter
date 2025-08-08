enum NStrokeStyle {
  solid('solid'),
  shortdash('shortdash'),
  shortdot('shortdot'),
  shortdashdot('shortdashdot'),
  shortdashdotdot('shortdashdotdot'),
  dot('dot'),
  dash('dash'),
  longdash('longdash'),
  dashdot('dashdot'),
  longdashdot('longdashdot'),
  longdashdotdot('longdashdotdot');

  const NStrokeStyle(this.value);

  final String value;
}
