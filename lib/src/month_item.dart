import 'package:flutter/material.dart';

/// Creates a Widget to represent the months.
class MonthItem extends StatelessWidget {
  final String name;
  final Function onTap;
  final bool isSelected;
  final Color? color;
  final Color? activeColor;
  final bool shrink;

  MonthItem({
    required this.name,
    required this.onTap,
    this.isSelected = false,
    this.color,
    this.activeColor,
    required this.shrink
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap as void Function()?,
      child: Text(
        this.name.toUpperCase(),
        style: TextStyle(
          fontSize: shrink ? 10 : 14,
          color: this.isSelected ? activeColor ?? Color(0xFF002265) : color ?? Colors.black87,
          fontWeight: this.isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
