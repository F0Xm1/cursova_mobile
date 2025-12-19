import 'package:flutter/material.dart';

/// Simple font helper without Google Fonts.
/// Uses system fonts that support Ukrainian.
class AppFonts {
  // Serif-like heading font
  static TextStyle playfairDisplay({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: color,
      height: height,
      fontFamily: 'Georgia',
    );
  }

  static TextStyle merriweather({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: color,
      height: height,
      fontFamily: 'Georgia',
    );
  }

  // Sans-serif body fonts
  static TextStyle lato({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color,
      height: height,
    );
  }

  static TextStyle roboto({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color,
      height: height,
      fontFamily: 'Roboto',
    );
  }
}