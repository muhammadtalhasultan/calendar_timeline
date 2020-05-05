import 'package:flutter/material.dart';
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

  CalendarTimeline({Key key,
    @required this.initialDate,
    @required this.firstDate,
    @required this.lastDate,
    @required this.onDateSelected,
    this.selectableDayPredicate,
    this.leftMargin = 0,
    this.dayColor,
    this.activeDayColor,
    this.activeBackgroundDayColor,
    this.monthColor,
    this.dotsColor,
    this.dayNameColor
  })
    : assert(initialDate != null),
      assert(firstDate != null),
      assert(lastDate != null),
      assert(initialDate.difference(firstDate).inDays >= 0, 'initialDate must be on or after firstDate'),
      assert(!initialDate.isAfter(lastDate), 'initialDate must be on or before lastDate'),
      assert(!firstDate.isAfter(lastDate), 'lastDate must be on or after firstDate'),
      assert(selectableDayPredicate == null || selectableDayPredicate(initialDate),
      'Provided initialDate must satisfy provided selectableDayPredicate'),
      super(key: key);

  @override
  _CalendarTimelineState createState() => _CalendarTimelineState();
}

class _CalendarTimelineState extends State<CalendarTimeline> {
  final ItemScrollController _controllerMonth = ItemScrollController();
  ScrollController _controllerDay;

  final DateFormat _formatterMonth = DateFormat.MMMM();
  final DateFormat _formatterDay = DateFormat.E();

  final double _dayItemExtend = 60.0;

  int _monthSelectedIndex;
  int _daySelectedIndex;
  double _scrollMonthAlignment;

  List<DateTime> _months = [];
  List<DateTime> _days = [];

  @override
  void initState() {
    super.initState();
    _initCalendar();
    _scrollMonthAlignment = widget.leftMargin / 440;
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
      child: ListView.builder(
        controller: _controllerDay,
        scrollDirection: Axis.horizontal,
        itemCount: _days.length,
        itemExtent: _dayItemExtend,
        padding: EdgeInsets.only(left: widget.leftMargin, right: 10),
        itemBuilder: (BuildContext context, int index) {

          final currentDay = _days[index];

          return _DayItem(
            isSelected: _daySelectedIndex == index,
            dayNumber: _days[index].day,
            shortName: _formatterDay.format(currentDay).substring(0, 3).capitalize(),
            onTap: () => _goToActualDay(index),
            available: widget.selectableDayPredicate == null ? true : widget.selectableDayPredicate(currentDay),
            dayColor: widget.dayColor,
            activeDayColor: widget.activeDayColor,
            activeDayBackgroundColor: widget.activeBackgroundDayColor,
            dotsColor: widget.dotsColor,
            dayNameColor: widget.dayNameColor,
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
        initialAlignment: _scrollMonthAlignment,
        itemScrollController: _controllerMonth,
        padding: EdgeInsets.only(left: widget.leftMargin),
        scrollDirection: Axis.horizontal,
        itemCount: _months.length,
        itemBuilder: (BuildContext context, int index) {
          final currentDate = _months[index];

          return Padding(
            padding: const EdgeInsets.only(right: 12.0, left: 4.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (widget.firstDate.year != currentDate.year && currentDate.month == 1)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: widget.monthColor, width: 1),
                          borderRadius: BorderRadius.circular(4)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 5.0),
                        child: Text(
                          DateFormat.y().format(currentDate),
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
                  name: _formatterMonth.format(currentDate),
                  onTap: () => _goToActualMonth(index),
                  color: widget.monthColor,
                ),
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
      if (day.month != selectedMonth.month || day.isAfter(widget.lastDate)) break;
      _days.add(day);
    }
  }

  _generateMonths() {
    DateTime date = DateTime(widget.firstDate.year, widget.firstDate.month);
    while (date.isBefore(widget.lastDate)) {
      _months.add(date);
      date = DateTime(date.year, date.month + 1);
    }
  }

  _resetCalendar(DateTime date) {
    _generateDays(date);
    _daySelectedIndex = null;
    _controllerDay.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  _goToActualMonth(int index) {
    _monthSelectedIndex = index;
    if (index < (_months.length - 4)) {
      _controllerMonth.scrollTo(
        index: index,
        alignment: _scrollMonthAlignment,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    }
    _resetCalendar(_months[index]);
    setState(() {});
  }

  _goToActualDay(int index) {
    double offset = index < 0 ? 0 : index * _dayItemExtend;
    if (offset > _controllerDay.position.maxScrollExtent) {
      offset = _controllerDay.position.maxScrollExtent;
    }

    _daySelectedIndex = index;
    _controllerDay.animateTo(
      offset,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );

    widget.onDateSelected(_days[index]);
    setState(() {});
  }

  _initCalendar() {
    _generateMonths();
    _generateDays(widget.initialDate);
    _monthSelectedIndex = _months.indexOf(
      _months.firstWhere((monthDate) => monthDate.year == widget.initialDate.year
        && monthDate.month == widget.initialDate.month)
    );
    _daySelectedIndex = _days.indexOf(
      _days.firstWhere((dayDate) => dayDate.day == widget.initialDate.day)
    );
    _controllerDay = ScrollController(
      initialScrollOffset:_daySelectedIndex * _dayItemExtend,
    );
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

  const _DayItem({Key key,
    @required this.dayNumber,
    @required this.shortName,
    @required this.isSelected,
    @required this.onTap,
    this.dayColor,
    this.activeDayColor,
    this.activeDayBackgroundColor,
    this.available = true,
    this.dotsColor,
    this.dayNameColor
  })
    : super(key: key);

  final double height = 70.0;
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
              fontSize: 32,
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
                    : dayColor?.withOpacity(0.5) ?? Theme.of(context).accentColor.withOpacity(0.5),
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
