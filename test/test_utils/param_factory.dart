import 'package:flutter/material.dart';

abstract class ParamFactory {
  // int
  static const int dayNumber = 1;

  // String
  static const String unCapitalizedString = "string";
  static const String capitalizedString = "String";
  static const String dayName = "MON";
  static const String monthName = "April";

  // Color
  static const Color activeColor = Colors.redAccent;
  static const Color textColor = Colors.blueAccent;

  // bool
  static const bool isNotSelected = false;
  static const bool isSelected = true;

  // FontWeight
  static const FontWeight bold = FontWeight.bold;
  static const FontWeight light = FontWeight.w300;

  // Functions
  static bool isContainerWithColor(Widget widget, Color color) {
    if (widget is! Container) return false;

    if (widget.color != null) {
      return widget.color == color;
    } else if (widget.decoration != null) {
      return (widget.decoration as BoxDecoration).color == color;
    } else {
      return false;
    }
  }

  static bool isTextWithColor(Widget widget, Color color) {
    if (widget is! Text || widget.style == null) return false;

    return widget.style!.color == color;
  }

  static bool isTextWithCFontWeight(Widget widget, FontWeight fontWeight) {
    if (widget is! Text || widget.style == null) return false;

    return widget.style!.fontWeight == fontWeight;
  }
}
