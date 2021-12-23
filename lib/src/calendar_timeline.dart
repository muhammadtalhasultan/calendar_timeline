import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'day_item.dart';
import 'month_item.dart';
import 'util/utils.dart';
import 'year_item.dart';

typedef OnDateSelected = void Function(DateTime?);

/// Creates a minimal, small profile calendar to select specific dates.
/// [initialDate] must not be [null], the same or after [firstDate] and
/// the same or before [lastDate]. [firstDate] must not be [null].
/// [lastDate] must not be null and the same or after [firstDate]
class CalendarTimeline extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final SelectableDayPredicate? selectableDayPredicate;
  final OnDateSelected onDateSelected;
  final double leftMargin;
  final Color? dayColor;
  final Color? activeDayColor;
  final Color? activeBackgroundDayColor;
  final Color? monthColor;
  final Color? dotsColor;
  final Color? dayNameColor;
  final String? locale;

  /// If true, it will show a separate row for the years.
  /// It defaults to false
  final bool showYears;

  CalendarTimeline({
    Key? key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateSelected,
    this.selectableDayPredicate,
    this.leftMargin = 0,
    this.dayColor,
    this.activeDayColor,
    this.activeBackgroundDayColor,
    this.monthColor,
    this.dotsColor,
    this.dayNameColor,
    this.locale,
    this.showYears = false,
  })  : assert(
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
  final ItemScrollController _controllerYear = ItemScrollController();
  final ItemScrollController _controllerMonth = ItemScrollController();
  final ItemScrollController _controllerDay = ItemScrollController();

  int? _yearSelectedIndex;
  int? _monthSelectedIndex;
  int? _daySelectedIndex;
  late double _scrollAlignment;

  List<DateTime> _years = [];
  List<DateTime> _months = [];
  List<DateTime> _days = [];
  DateTime? _selectedDate;

  late String _locale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initCalendar();
  }

  @override
  void didUpdateWidget(CalendarTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initCalendar();
    if (widget.showYears) _moveToYearIndex(_yearSelectedIndex ?? 0);
    _moveToMonthIndex(_monthSelectedIndex ?? 0);
    _moveToDayIndex(_daySelectedIndex ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    _scrollAlignment = widget.leftMargin / MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (widget.showYears) _buildYearList(),
        _buildMonthList(),
        _buildDayList(),
      ],
    );
  }

  /// Creates the row with the day of the [selectedDate.month]. If the
  /// [selectedDate.year] && [selectedDate.month] is the [widget.firstDate] or [widget.lastDate]
  /// the days show will be the available
  SizedBox _buildDayList() {
    return SizedBox(
      height: 75,
      child: ScrollablePositionedList.builder(
        itemScrollController: _controllerDay,
        initialScrollIndex: _daySelectedIndex ?? 0,
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
              DayItem(
                isSelected: _daySelectedIndex == index,
                dayNumber: currentDay.day,
                shortName: shortName.length > 3
                    ? shortName.substring(0, 3)
                    : shortName,
                onTap: () => _goToActualDay(index),
                available: widget.selectableDayPredicate == null
                    ? true
                    : widget.selectableDayPredicate!(currentDay),
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

  /// Creates the row with all the months in the calendar. If [widget.showYears] is set to true
  /// it will only show the months allowed in the selected year. By default it will show all
  /// months in the calendar and the small version of [YearItem] for each year in between
  Widget _buildMonthList() {
    return Container(
      height: 40,
      child: ScrollablePositionedList.builder(
        initialScrollIndex: _monthSelectedIndex ?? 0,
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
                    currentDate.month == 1 &&
                    !widget.showYears)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: YearItem(
                      name: DateFormat.y(_locale).format(currentDate),
                      color: widget.monthColor,
                      onTap: (){},
                    ),
                  ),
                MonthItem(
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

  /// Creates the row with all the years in the calendar. It will only show if
  /// [widget.showYears] is set to true. It is false by default
  Widget _buildYearList() {
    return Container(
      height: 40,
      child: ScrollablePositionedList.builder(
        initialScrollIndex: _yearSelectedIndex!,
        initialAlignment: _scrollAlignment,
        itemScrollController: _controllerYear,
        padding: EdgeInsets.only(left: widget.leftMargin),
        scrollDirection: Axis.horizontal,
        itemCount: _years.length,
        itemBuilder: (BuildContext context, int index) {
          final currentDate = _years[index];
          final yearName = DateFormat.y(_locale).format(currentDate);

          return Padding(
            padding: const EdgeInsets.only(right: 12.0, left: 4.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                YearItem(
                  isSelected: _yearSelectedIndex == index,
                  name: yearName,
                  onTap: () => _goToActualYear(index),
                  color: widget.monthColor,
                  small: false,
                ),
                if (index == _years.length - 1)
                  SizedBox(
                    width: MediaQuery.of(context).size.width -
                        widget.leftMargin -
                        (yearName.length * 10),
                  )
              ],
            ),
          );
        },
      ),
    );
  }

  /// It will populate the [_days] list with all the allowed days. Adding all days of the month
  /// when the [selectedDate.month] is not the first or the last in [widget.firstDate] or [widget.lastDate].
  /// In that case it will only show the allowed days from and up to the specified in [widget.firstDate]
  /// and [widget.lastDate]
  _generateDays(DateTime? selectedDate) {
    _days.clear();
    for (var i = 1; i <= 31; i++) {
      final day = DateTime(selectedDate!.year, selectedDate.month, i);
      if (day.difference(widget.firstDate).inDays < 0) continue;
      if (day.month != selectedDate.month || day.isAfter(widget.lastDate))
        break;
      _days.add(day);
    }
  }

  /// It will populate the [_months] list. If [widget.showYears] is true, it will add from January
  /// to December, unless the selected year is the [widget.firstDate.year] or the [widget.lastDate.year].
  /// In that case it will only from and up to the allowed months in [widget.firstDate] and [widget.lastDate].
  /// By default, when [widget.showYears] is false, it will add all months from [widget.firstDate] to
  /// [widget.lastDate] and all in between
  _generateMonths(DateTime? selectedDate) {
    _months.clear();
    if (widget.showYears) {
      int month = selectedDate!.year == widget.firstDate.year
          ? widget.firstDate.month
          : 1;
      DateTime date = DateTime(selectedDate.year, month);
      while (date.isBefore(DateTime(selectedDate.year + 1)) &&
          date.isBefore(widget.lastDate)) {
        _months.add(date);
        date = DateTime(date.year, date.month + 1);
      }
    } else {
      DateTime date = DateTime(widget.firstDate.year, widget.firstDate.month);
      while (date.isBefore(widget.lastDate)) {
        _months.add(date);
        date = DateTime(date.year, date.month + 1);
      }
    }
  }

  /// It will populate the [_years] list with the years between firstDate and lastDate
  _generateYears() {
    _years.clear();
    DateTime date = widget.firstDate;
    while (date.isBefore(widget.lastDate)) {
      _years.add(date);
      date = DateTime(date.year + 1);
    }
  }

  /// It will reset the calendar to the initial date
  _resetCalendar(DateTime date) {
    if (widget.showYears) {
      _generateMonths(date);
      _moveToMonthIndex(_monthSelectedIndex ?? 0);
    }
    _generateDays(date);
    _daySelectedIndex = date.month == _selectedDate!.month
        ? _days.indexOf(
            _days.firstWhere((dayDate) => dayDate.day == _selectedDate!.day))
        : null;
    _moveToDayIndex(_daySelectedIndex ?? 0);
  }

  _goToActualYear(int index) {
    _moveToYearIndex(index);
    _yearSelectedIndex = index;
    _monthSelectedIndex = null;
    _resetCalendar(_years[index]);
    setState(() {});
  }

  void _moveToYearIndex(int index) {
    _controllerYear.scrollTo(
      index: index,
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

  selectedYear() {
    _yearSelectedIndex = _years.indexOf(_years
        .firstWhere((yearDate) => yearDate.year == widget.initialDate.year));
  }

  selectedMonth() {
    if (widget.showYears)
      _monthSelectedIndex = _months.indexOf(_months.firstWhere(
          (monthDate) => monthDate.month == widget.initialDate.month));
    else
      _monthSelectedIndex = _months.indexOf(_months.firstWhere((monthDate) =>
          monthDate.year == widget.initialDate.year &&
          monthDate.month == widget.initialDate.month));
  }

  selectedDay() {
    _daySelectedIndex = _days.indexOf(
        _days.firstWhere((dayDate) => dayDate.day == widget.initialDate.day));
  }

  /// Initializes the calendar. It will be executed every time a new date is selected
  _initCalendar() {
    _locale = widget.locale ?? Localizations.localeOf(context).languageCode;
    initializeDateFormatting(_locale);
    _selectedDate = widget.initialDate;
    if (widget.showYears) {
      _generateYears();
      selectedYear();
    }
    _generateMonths(_selectedDate);
    selectedMonth();
    _generateDays(_selectedDate);
    selectedDay();
  }
}
