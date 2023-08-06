import 'package:flutter/material.dart';

/// Creates a Widget representing the day.
class DayItem extends StatelessWidget {
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
    required this.height,
    required this.width,
    required this.shrinkHeight,
    required this.shrinkWidth,
    required this.fontSize,
    required this.shrinkFontSize,
    required this.dayNameFontSize,
    required this.shrinkDayNameFontSize,
    this.shrink = false,
  }) : super(key: key);
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
  final double height;
  final double width;
  final double shrinkHeight;
  final double shrinkWidth;
  final double fontSize;
  final double shrinkFontSize;
  final double dayNameFontSize;
  final double shrinkDayNameFontSize;
  final bool shrink;

  GestureDetector _buildDay(BuildContext context) {
    final textStyle = TextStyle(
      color: available
          ? dayColor ?? Theme.of(context).colorScheme.secondary
          : dayColor?.withOpacity(0.5) ??
              Theme.of(context).colorScheme.secondary.withOpacity(0.5),
      fontSize: shrink ? shrinkFontSize : fontSize,
      height: 1,
    );
    final selectedStyle = TextStyle(
      color: activeDayColor ?? Colors.white,
      fontSize: shrink ? shrinkFontSize : fontSize,
      fontWeight: FontWeight.bold,
      height: 1,
    );

    return GestureDetector(
      onTap: available ? onTap as void Function()? : null,
      child: Container(
        decoration: isSelected
            ? BoxDecoration(
                color: activeDayBackgroundColor ??
                    Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              )
            : const BoxDecoration(color: Colors.transparent),
        height: shrink ? shrinkHeight : height,
        width: shrink ? shrinkWidth : width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            if (isSelected)
              Column(
                children: [
                  SizedBox(height: shrink ? 6 : 7),
                  if (!shrink) _buildDots(),
                  SizedBox(height: shrink ? 6 : 7),
                ],
              )
            else
              SizedBox(height: shrink ? 12 : 19),
            Center(
              child: Text(
                dayNumber.toString(),
                style: isSelected ? selectedStyle : textStyle,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: shrink ? 6 : 7),
              child: Text(
                shortName,
                style: TextStyle(
                  color: isSelected
                      ? dayNameColor ?? activeDayColor ?? Colors.white
                      : Colors.transparent,
                  fontWeight: FontWeight.bold,
                  fontSize: shrink ? shrinkDayNameFontSize : dayNameFontSize,
                ),
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
      decoration: BoxDecoration(
        color: dotsColor ?? activeDayColor ?? Colors.white,
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
