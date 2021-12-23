import 'package:flutter/material.dart';

/// Creates a Widget representing the day.
class DayItem extends StatelessWidget {
  final int dayNumber;
  final String shortName;
  final bool isSelected;
  final Function onTap;
  final Color? dayColor;
  final Color? activeDayColor;
  final Color? activeDayBackgroundColor;
  final bool available;
  final Color? dotsColor;
  final Color? dayNameColor;

  const DayItem({
    Key? key,
    required this.dayNumber,
    required this.shortName,
    required this.onTap,
    this.isSelected = false,
    this.dayColor,
    this.activeDayColor,
    this.activeDayBackgroundColor,
    this.available = true,
    this.dotsColor,
    this.dayNameColor,
  }) : super(key: key);

  final double height = 70.0;
  final double width = 60.0;

  _buildDay(BuildContext context) {
    final textStyle = TextStyle(
      color: available
        ? dayColor ?? Theme.of(context).colorScheme.secondary
        : dayColor?.withOpacity(0.5) ??
        Theme.of(context).colorScheme.secondary.withOpacity(0.5),
      fontSize: 32,
      fontWeight: FontWeight.normal);
    final selectedStyle = TextStyle(
      color: activeDayColor ?? Colors.white,
      fontSize: 32,
      fontWeight: FontWeight.bold,
      height: 0.8,
    );

    return GestureDetector(
      onTap: available ? onTap as void Function()? : null,
      child: Container(
        decoration: isSelected
          ? BoxDecoration(
          color:
          activeDayBackgroundColor ?? Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12.0),
        )
          : BoxDecoration(color: Colors.transparent),
        height: height,
        width: width,
        child: Column(
          children: <Widget>[
            if (isSelected) ...[
              SizedBox(height: 7),
              _buildDots(),
              SizedBox(height: 12),
            ] else
              SizedBox(height: 14),
            Text(
              dayNumber.toString(),
              style: isSelected ? selectedStyle : textStyle,
            ),
            if (isSelected)
              Text(
                shortName,
                style: TextStyle(
                  color: dayNameColor ?? activeDayColor ?? Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDots() {
    final dot = Container(
      height: 5,
      width: 5,
      decoration: new BoxDecoration(
        color: this.dotsColor ?? this.activeDayColor ?? Colors.white,
        shape: BoxShape.circle,
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [dot, dot],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildDay(context);
  }
}