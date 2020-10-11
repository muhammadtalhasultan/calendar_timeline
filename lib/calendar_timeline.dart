import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

typedef OnDateSelected = void Function(DateTime);

class CalendarTimeline extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final SelectableDayPredicate selectableDayPredicate;
  final OnDateSelected onDateSelected;
  final double leftMargin;
  final Color dayColor;
  final Color activeDayColor;
  final Color activeBackgroundDayColor;
  final Color monthColor;
  final Color dotsColor;
  final Color dayNameColor;
  final String locale;
  final double dayTextSize;

  CalendarTimeline({
    Key key,
    @required this.initialDate,
    @required this.firstDate,
    @required this.lastDate,
    @required this.onDateSelected,
    this.selectableDayPredicate,
    this.leftMargin = 0,
    this.dayColor,
    this.dayTextSize,
    this.activeDayColor,
    this.activeBackgroundDayColor,
    this.monthColor,
    this.dotsColor,
    this.dayNameColor,
    this.locale,
  })  : assert(initialDate != null),
        assert(firstDate != null),
        assert(lastDate != null),
        assert(
          initialDate.difference(firstDate).inDays >= 0,
          'initialDate must be on or after firstDate',
        ),
        assert(
          !initialDate.isAfter(lastDate),
          'initialDate must be on or before lastDate',
        ),
        assert(
          !firstDate.isAfter(lastDate),
          'lastDate must be on or after firstDate',
        ),
        assert(
          selectableDayPredicate == null || selectableDayPredicate(initialDate),
          'Provided initialDate must satisfy provided selectableDayPredicate',
        ),
        assert(
          locale == null || dateTimeSymbolMap().containsKey(locale),
          'Provided locale value doesn\'t exist',
        ),
        super(key: key);

  @override
  _CalendarTimelineState createState() => _CalendarTimelineState();
}

class _CalendarTimelineState extends State<CalendarTimeline> {
  final ItemScrollController _controllerMonth = ItemScrollController();
  final ItemScrollController _controllerDay = ItemScrollController();

  int _monthSelectedIndex;
  int _daySelectedIndex;
  double _scrollAlignment;

  List<DateTime> _months = [];
  List<DateTime> _days = [];
  DateTime _selectedDate;

  String get _locale =>
      widget.locale ?? Localizations.localeOf(context).languageCode;

  @override
  void initState() {
    super.initState();
    _initCalendar();
    _scrollAlignment = widget.leftMargin / 440;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      initializeDateFormatting(_locale);
    });
  }

  @override
  void didUpdateWidget(CalendarTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initCalendar();
    _moveToMonthIndex(_monthSelectedIndex);
    _moveToDayIndex(_daySelectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildMonthList(),
        _buildDayList(),
      ],
    );
  }

  SizedBox _buildDayList() {
    return SizedBox(
      height: 75,
      child: ScrollablePositionedList.builder(
        itemScrollController: _controllerDay,
        initialScrollIndex: _daySelectedIndex,
        initialAlignment: _scrollAlignment,
        scrollDirection: Axis.horizontal,
        itemCount: _days.length,
        padding: EdgeInsets.only(left: widget.leftMargin, right: 10),
        itemBuilder: (BuildContext context, int index) {
          final currentDay = _days[index];
          final shortName =
              DateFormat.E(_locale).format(currentDay).capitalize();
          return Row(
            children: <Widget>[
              _DayItem(
                isSelected: _daySelectedIndex == index,
                dayNumber: currentDay.day,
                shortName: shortName.length > 3
                    ? shortName.substring(0, 3)
                    : shortName,
                onTap: () => _goToActualDay(index),
                available: widget.selectableDayPredicate == null
                    ? true
                    : widget.selectableDayPredicate(currentDay),
                dayColor: widget.dayColor,
                activeDayColor: widget.activeDayColor,
                activeDayBackgroundColor: widget.activeBackgroundDayColor,
                dotsColor: widget.dotsColor,
                dayNameColor: widget.dayNameColor,
              ),
              if (index == _days.length - 1)
                SizedBox(
                    width: MediaQuery.of(context).size.width -
                        widget.leftMargin -
                        65)
            ],
          );
        },
      ),
    );
  }

  Widget _buildMonthList() {
    return Container(
      height: 40,
      child: ScrollablePositionedList.builder(
        initialScrollIndex: _monthSelectedIndex,
        initialAlignment: _scrollAlignment,
        itemScrollController: _controllerMonth,
        padding: EdgeInsets.only(left: widget.leftMargin),
        scrollDirection: Axis.horizontal,
        itemCount: _months.length,
        itemBuilder: (BuildContext context, int index) {
          final currentDate = _months[index];
          final monthName = DateFormat.MMMM(_locale).format(currentDate);

          return Padding(
            padding: const EdgeInsets.only(right: 12.0, left: 4.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (widget.firstDate.year != currentDate.year &&
                    currentDate.month == 1)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: widget.monthColor, width: 1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14.0, vertical: 5.0),
                        child: Text(
                          DateFormat.y(_locale).format(currentDate),
                          style: TextStyle(
                            color: widget.monthColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                MonthName(
                  isSelected: _monthSelectedIndex == index,
                  name: monthName,
                  onTap: () => _goToActualMonth(index),
                  color: widget.monthColor,
                ),
                if (index == _months.length - 1)
                  SizedBox(
                    width: MediaQuery.of(context).size.width -
                        widget.leftMargin -
                        (monthName.length * 10),
                  )
              ],
            ),
          );
        },
      ),
    );
  }

  _generateDays(DateTime selectedMonth) {
    _days.clear();
    for (var i = 1; i <= 31; i++) {
      final day = DateTime(selectedMonth.year, selectedMonth.month, i);
      if (day.difference(widget.firstDate).inDays < 0) continue;
      if (day.month != selectedMonth.month || day.isAfter(widget.lastDate))
        break;
      _days.add(day);
    }
  }

  _generateMonths() {
    _months.clear();
    DateTime date = DateTime(widget.firstDate.year, widget.firstDate.month);
    while (date.isBefore(widget.lastDate)) {
      _months.add(date);
      date = DateTime(date.year, date.month + 1);
    }
  }

  _resetCalendar(DateTime date) {
    _generateDays(date);
    _daySelectedIndex = date.month == _selectedDate.month
        ? _days.indexOf(
            _days.firstWhere((dayDate) => dayDate.day == _selectedDate.day))
        : null;
    _controllerDay.scrollTo(
      index: _daySelectedIndex ?? 0,
      alignment: _scrollAlignment,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  _goToActualMonth(int index) {
    _moveToMonthIndex(index);
    _monthSelectedIndex = index;
    _resetCalendar(_months[index]);
    setState(() {});
  }

  void _moveToMonthIndex(int index) {
    _controllerMonth.scrollTo(
      index: index,
      alignment: _scrollAlignment,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  _goToActualDay(int index) {
    _moveToDayIndex(index);
    _daySelectedIndex = index;
    _selectedDate = _days[index];
    widget.onDateSelected(_selectedDate);
    setState(() {});
  }

  void _moveToDayIndex(int index) {
    _controllerDay.scrollTo(
      index: index,
      alignment: _scrollAlignment,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  _initCalendar() {
    _selectedDate = widget.initialDate;
    _generateMonths();
    _generateDays(_selectedDate);
    _monthSelectedIndex = _months.indexOf(_months.firstWhere((monthDate) =>
        monthDate.year == widget.initialDate.year &&
        monthDate.month == widget.initialDate.month));
    _daySelectedIndex = _days.indexOf(
        _days.firstWhere((dayDate) => dayDate.day == widget.initialDate.day));
  }
}

class MonthName extends StatelessWidget {
  final String name;
  final Function onTap;
  final bool isSelected;
  final Color color;

  MonthName({this.name, this.onTap, this.isSelected, this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Text(
        this.name.toUpperCase(),
        style: TextStyle(
          fontSize: 14,
          color: color ?? Colors.black87,
          fontWeight: this.isSelected ? FontWeight.bold : FontWeight.w300,
        ),
      ),
    );
  }
}

class _DayItem extends StatelessWidget {
  final int dayNumber;
  final String shortName;
  final bool isSelected;
  final Function onTap;
  final Color dayColor;
  final Color activeDayColor;
  final Color activeDayBackgroundColor;
  final bool available;
  final Color dotsColor;
  final Color dayNameColor;

  const _DayItem({
    Key key,
    @required this.dayNumber,
    @required this.shortName,
    @required this.isSelected,
    @required this.onTap,
    this.dayColor,
    this.activeDayColor,
    this.activeDayBackgroundColor,
    this.available = true,
    this.dotsColor,
    this.dayNameColor,
  }) : super(key: key);

  final double height = 75.0;
  final double width = 60.0;

  _buildActiveDay(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: activeDayBackgroundColor ?? Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      height: height,
      width: width,
      child: Column(
        children: <Widget>[
          SizedBox(height: 7),
          _buildDots(),
          SizedBox(height: 12),
          Text(
            dayNumber.toString(),
            style: TextStyle(
              color: activeDayColor ?? Colors.white,
              fontSize: widget.dayTextSize,
              fontWeight: FontWeight.bold,
              height: 0.8,
            ),
          ),
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

  _buildDay(BuildContext context) {
    return GestureDetector(
      onTap: available ? onTap : null,
      child: Container(
        height: height,
        width: width,
        child: Column(
          children: <Widget>[
            SizedBox(height: 14),
            Text(
              dayNumber.toString(),
              style: TextStyle(
                  color: available
                      ? dayColor ?? Theme.of(context).accentColor
                      : dayColor?.withOpacity(0.5) ??
                          Theme.of(context).accentColor.withOpacity(0.5),
                  fontSize: 32,
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isSelected ? _buildActiveDay(context) : _buildDay(context);
  }
}

extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + this.substring(1);
  }
}
