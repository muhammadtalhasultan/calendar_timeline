import 'package:flutter/material.dart';

abstract class ParamFactory {
  // int
  static const int dayNumber = 1;

  // String
  static const String unCapitalizedString = "string";
  static const String capitalizedString = "String";
  static const String dayName = "MON";

  // Color
  static const Color activeColor = Colors.redAccent;

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
}
