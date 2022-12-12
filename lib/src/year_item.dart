import 'package:flutter/material.dart';

/// Creates a Widget to represent the years. By default it will show the smaller version
/// in the months row. If [small] is set to false it will show the bigger version for the
/// years row. In the smaller version the [onTap] property is not available
class YearItem extends StatelessWidget {
  const YearItem({
    Key? key,
    required this.name,
    required this.onTap,
    this.isSelected = false,
    this.small = true,
    this.color,
    this.shrink = false,
  }) : super(key: key);
  final String name;
  final Function onTap;
  final bool isSelected;
  final Color? color;
  final bool small;
  final bool shrink;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: small ? null : onTap as void Function()?,
      // ignore: use_decorated_box
      child: Container(
        decoration: isSelected || small
            ? BoxDecoration(
                border: Border.all(color: color ?? Colors.black87),
                borderRadius: BorderRadius.circular(4),
              )
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          child: Text(
            name.toUpperCase(),
            style: TextStyle(
              fontSize: shrink
                  ? 9
                  : small
                      ? 12
                      : 20,
              color: color ?? Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
