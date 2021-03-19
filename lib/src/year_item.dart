import 'package:flutter/material.dart';

/// Creates a Widget to represent the years. By default it will show the smaller version
/// in the months row. If [small] is set to false it will show the bigger version for the
/// years row. In the smaller version the [onTap] property is not available
class YearItem extends StatelessWidget {
  final String name;
  final Function onTap;
  final bool isSelected;
  final Color? color;
  final bool small;

  YearItem({
    required this.name,
    required this.onTap,
    this.isSelected = false,
    this.small = true,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: small ? null : onTap as void Function()?,
      child: Container(
        decoration: isSelected || small
          ? BoxDecoration(
          border: Border.all(color: color ?? Colors.black87, width: 1),
          borderRadius: BorderRadius.circular(4),
        )
          : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 5.0),
          child: Text(
            name.toUpperCase(),
            style: TextStyle(
              fontSize: small ? 12 : 20,
              color: color ?? Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}