import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    if (hexColor.isEmpty) hexColor = 'ffffff';
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

extension ColorToString on Color {
  String get colorToString => value.toRadixString(16);
}

const lightScaffoldBackgroundColor = Color.fromARGB(255, 242, 243, 245);
const darkScaffoldBackgroundColor = Colors.black;
