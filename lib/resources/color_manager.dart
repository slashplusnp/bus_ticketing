import 'package:flutter/material.dart' show Color;

import '../extensions/extensions.dart';

class ColorManager {
  static final Color _black = HexColor.fromHex('#000000');
  static final Color _white = HexColor.fromHex('#FFFFFF');
  // static final Color _darkGrey = HexColor.fromHex('#1C1C1C');
  static final Color _lightGrey = HexColor.fromHex('#d3d3d3');
  static final Color _textGrey = HexColor.fromHex('#BABABA');
  static final Color _limeGreen = HexColor.fromHex('#70A701');
  static final Color _green = HexColor.fromHex('#38FF38');
  static final Color _red = HexColor.fromHex('#FF3838');
  static final Color _crimsonRed = HexColor.fromHex('#DC143C');

  static final Color primary = _limeGreen;
  static final Color background = _white;
  static final Color foreground = _black;
  static final Color backgroundCard = _lightGrey;
  static final Color greyText = _textGrey;
  static final Color statusActive = _green;
  static final Color statusInactive = _red;
  static final Color error = _red;
  static final Color remove = _crimsonRed;
}
