library calendar_timeline;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

typedef OnDaySelected = void Function(DateTime);

class CalendarTimeline extends StatefulWidget {
  final DateTime actualDate;
  final OnDaySelected onDaySelected;
  final double leftMargin;

  const CalendarTimeline(
    {Key key,
      @required this.actualDate,
      @required this.onDaySelected,
      this.leftMargin = 0})
    : super(key: key);

  @override
  _CalendarTimelineState createState() => _CalendarTimelineState();
}

class _CalendarTimelineState extends State<CalendarTimeline> {
  final ItemScrollController _controllerMonth = ItemScrollController();
  ScrollController _controllerDay;

  final DateFormat _formatterMonth = DateFormat.MMMM();
  final DateFormat _formatterDay = DateFormat.E();

  final double _dayItemExtend = 60.0;

  final _actualYear = DateTime.now().year;

  int _monthSelectedIndex;
  int _daySelectedIndex;
  double _scrollMonthAlignment;

  List<DateTime> _daysPerMonth = [];

  _generateDaysPerMonth(DateTime time) {
    _daysPerMonth = [];
    for (var i = 1; i <= 31; i++) {
      final newDay = DateTime(_actualYear, time.month, i);
      if (newDay.month != time.month) break;
      _daysPerMonth.add(newDay);
    }
  }

  _resetCalendar(int month) {
    _generateDaysPerMonth(DateTime(_actualYear, month));
    _daySelectedIndex = null;
    _controllerDay.animateTo(0,
      duration: Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  _goToActualMonth(int index) {
    _monthSelectedIndex = index;
    _controllerMonth.scrollTo(
      index: index,
      alignment: _scrollMonthAlignment,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeIn);
    _resetCalendar(index);
  }

  _goToActualDay(int index) {
    _daySelectedIndex = index;
    _controllerDay.animateTo((index * _dayItemExtend) - widget.leftMargin,
      duration: Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  _initCalendar() {
    _generateDaysPerMonth(widget.actualDate);
    _monthSelectedIndex = widget.actualDate.month;
    _controllerDay = ScrollController(
      initialScrollOffset:
      (widget.actualDate.day * _dayItemExtend) - widget.leftMargin);
    _daySelectedIndex = widget.actualDate.day;
  }

  @override
  void initState() {
    super.initState();
    _scrollMonthAlignment = widget.leftMargin / 330;
    _initCalendar();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 50,
          child: ScrollablePositionedList.builder(
            initialScrollIndex: _monthSelectedIndex,
            initialAlignment: _scrollMonthAlignment,
            itemScrollController: _controllerMonth,
            scrollDirection: Axis.horizontal,
            itemCount: DateTime.monthsPerYear * 2,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 4.0),
                child: Center(
                  child: MonthName(
                    isSelected: _monthSelectedIndex == index,
                    name: _formatterMonth.format(DateTime(_actualYear, index)),
                    onTap: () {
                      _goToActualMonth(index);
                      setState(() {});
                    },
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 70,
          child: ListView.builder(
            controller: _controllerDay,
            scrollDirection: Axis.horizontal,
            itemCount: _daysPerMonth.length,
            itemExtent: _dayItemExtend,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: _DayItem(
                  isSelected: _daySelectedIndex == index,
                  dayNumber: _daysPerMonth[index].day,
                  shortName: _formatterDay.format(_daysPerMonth[index]).substring(0, 2),
                  onTap: () {
                    _goToActualDay(index);
                    widget.onDaySelected(_daysPerMonth[index]);
                    setState(() {});
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class MonthName extends StatelessWidget {
  final String name;
  final Function onTap;
  final bool isSelected;

  MonthName({this.name, this.onTap, this.isSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Text(
        this.name.toUpperCase(),
        style: TextStyle(
          fontSize: 14,
          fontWeight: this.isSelected ? FontWeight.bold : FontWeight.w300),
      ),
    );
  }
}

class _DayItem extends StatelessWidget {
  final int dayNumber;
  final String shortName;
  final bool isSelected;
  final Function onTap;

  const _DayItem(
    {Key key,
      @required this.dayNumber,
      @required this.shortName,
      @required this.isSelected,
      @required this.onTap})
    : super(key: key);

  final double height = 70.0;
  final double width = 60.0;

  _activeDay(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const _CalendarDots(),
            Text(
              dayNumber.toString(),
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 32,
                fontWeight: FontWeight.bold),
            ),
            Text(shortName,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14))
          ],
        ),
      ),
    );
  }

  _passiveDay(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              dayNumber.toString(),
              style: TextStyle(
                color: Theme.of(context).accentColor,
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
    return isSelected ? _activeDay(context) : _passiveDay(context);
  }
}

class _CalendarDots extends StatelessWidget {
  const _CalendarDots({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildDot(),
        _buildDot(),
      ],
    );
  }

  Container _buildDot() {
    return Container(
        height: 5,
        width: 5,
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      );
  }
}
