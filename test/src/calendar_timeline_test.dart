import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../test_utils/test_utils.dart';
import '../helper/helper.dart';

void main() {
  setUpAll(() {
    initializeDateFormatting('es');
  });

  group(
    'CalendarTimeline',
    () {
      group(
        'Render',
        () {
          testWidgets('a list of days', (WidgetTester tester) async {
            await tester.pumpApp(
              CalendarTimeline(
                firstDate: ParamFactory.firstDate,
                lastDate: ParamFactory.lastDate,
                initialDate: ParamFactory.initialDate,
                onDateSelected: (dateTime) {},
              ),
            );

            final dateDaysDifference = ParamFactory.lastDate
                    .difference(ParamFactory.firstDate)
                    .inDays -
                1;
            final foundDays = find.textContaining(RegExp(r'[0-9]'));
            expect(foundDays, findsNWidgets(dateDaysDifference));
          });
          testWidgets(
            'a list of months in uppercase',
            (WidgetTester tester) async {
              await tester.pumpApp(
                CalendarTimeline(
                  firstDate: ParamFactory.firstDate,
                  lastDate: ParamFactory.lastDate,
                  initialDate: ParamFactory.initialDate,
                  onDateSelected: (dateTime) {},
                ),
              );

              final foundMonths =
                  find.text(ParamFactory.monthName.toUpperCase());
              expect(foundMonths, findsNWidgets(1));
            },
          );
          testWidgets(
            'years if [showYears] is true',
            (WidgetTester tester) async {
              await tester.pumpApp(
                CalendarTimeline(
                  firstDate: ParamFactory.firstDate,
                  lastDate: ParamFactory.lastDate,
                  initialDate: ParamFactory.initialDate,
                  showYears: ParamFactory.isNotShowed,
                  onDateSelected: (dateTime) {},
                ),
              );

              final foundYears = find.text(ParamFactory.yearName);
              expect(foundYears, findsNothing);
            },
          );
          testWidgets(
            'years are not displayed if [showYears] is false',
            (WidgetTester tester) async {
              await tester.pumpApp(
                CalendarTimeline(
                  firstDate: ParamFactory.firstDate,
                  lastDate: ParamFactory.lastDate,
                  initialDate: ParamFactory.initialDate,
                  showYears: ParamFactory.isShowed,
                  onDateSelected: (dateTime) {},
                ),
              );

              final foundYears = find.text(ParamFactory.yearName);
              expect(foundYears, findsOneWidget);
            },
          );
        },
      );
      group(
        'Style',
        () {
          testWidgets('show only a selected day', (WidgetTester tester) async {
            await tester.pumpApp(
              CalendarTimeline(
                firstDate: ParamFactory.firstDate,
                lastDate: ParamFactory.lastDate,
                initialDate: ParamFactory.initialDate,
                activeBackgroundDayColor: ParamFactory.activeColor,
                onDateSelected: (dateTime) {},
              ),
            );

            final foundActiveDays = find.byWidgetPredicate(
              (widget) => ParamFactory.isContainerWithColor(
                widget,
                ParamFactory.activeColor,
              ),
            );

            expect(foundActiveDays, findsOneWidget);
          });
          testWidgets(
            'show only a selected month',
            (WidgetTester tester) async {
              await tester.pumpApp(
                CalendarTimeline(
                  firstDate: ParamFactory.firstDate,
                  lastDate: ParamFactory.lastDate,
                  initialDate: ParamFactory.initialDate,
                  onDateSelected: (dateTime) {},
                ),
              );

              final foundActiveDays = find.byWidgetPredicate(
                (widget) =>
                    ParamFactory.isTextWithFontWeight(
                      widget,
                      ParamFactory.bold,
                    ) &&
                    (widget as Text).data ==
                        ParamFactory.monthName.toUpperCase(),
              );

              expect(foundActiveDays, findsOneWidget);
            },
          );
        },
      );
      group(
        'Method',
        () {
          testWidgets(
            'when tap a day or month call [onDateSelected]',
            (WidgetTester tester) async {
              var methodCalls = 0;
              final onTap = () => methodCalls++;

              await tester.pumpApp(
                CalendarTimeline(
                  firstDate: ParamFactory.firstDate,
                  lastDate: ParamFactory.lastDate,
                  initialDate: ParamFactory.initialDate,
                  onDateSelected: (dateTime) => onTap(),
                ),
              );

              expect(methodCalls, isZero);

              final dayWidget = find.text('3');
              await tester.tap(dayWidget);
              expect(methodCalls, 1);
            },
          );
        },
      );
    },
  );
}
