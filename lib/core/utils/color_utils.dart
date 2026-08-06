import 'package:flutter/material.dart';

Color parseHexColor(String hex) {
  final value = int.parse(hex.substring(1), radix: 16);
  return Color(0xFF000000 | value);
}
