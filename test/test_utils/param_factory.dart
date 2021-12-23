import 'package:flutter/material.dart';

abstract class ParamFactory {
  // int
  static const int dayNumber = 1;

  // double
  static const double smallTextSize = 12;
  static const double normalTextSize = 20;

  // String
  static const String capitalizedString = "String";
  static const String dayName = "MON";
  static const String monthName = "January";
  static const String unCapitalizedString = "string";
  static const String yearName = '2020';

  // Color
  static const Color activeColor = Colors.redAccent;
  static const Color textColor = Colors.blueAccent;
  static const Color dotColor = Colors.white;

  // bool
  static const bool isNotSelected = false;
  static const bool isSelected = true;
  static const bool isNotSmall = false;
  static const bool isSmall = true;
  static const bool isNotShowed = false;
  static const bool isShowed = true;

  // FontWeight
  static const FontWeight bold = FontWeight.bold;
  static const FontWeight light = FontWeight.w300;

  // DateTime
  static final DateTime firstDate =  DateTime(2020);
  static final DateTime lastDate =  DateTime(2020, 1, 5);
  static final DateTime initialDate =  DateTime(2020, 1, 3);


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

  static bool isContainerWithDecoration(
    Widget widget,
    Decoration decoration,
  ) {
    if (widget is! Container || widget.decoration == null) return false;

    return widget.decoration == decoration;
  }

  static bool isTextWithColor(Widget widget, Color color) {
    if (widget is! Text || widget.style == null) return false;

    return widget.style!.color == color;
  }

  static bool isTextWithFontSize(Widget widget, double fontSize) {
    if (widget is! Text || widget.style == null) return false;

    return widget.style!.fontSize == fontSize;
  }

  static bool isTextWithFontWeight(Widget widget, FontWeight fontWeight) {
    if (widget is! Text || widget.style == null) return false;

    return widget.style!.fontWeight == fontWeight;
  }
}
