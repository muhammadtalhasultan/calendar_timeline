import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calendar_timeline/calendar_timeline.dart';

import '../helper/helper.dart';
import '../test_utils/test_utils.dart';

void main() {
  group(
    'MonthItem',
    () {
      group(
        'Render',
        () {
          testWidgets(
            'text in uppercase',
            (WidgetTester tester) async {
              await tester.pumpApp(
                MonthItem(
                  name: ParamFactory.monthName,
                  onTap: () {},
                ),
              );

              final upperCasedName =
                  find.text(ParamFactory.monthName.toUpperCase());
              expect(upperCasedName, findsOneWidget);
            },
          );
        },
      );
      group('style', () {
        testWidgets(
          'we can use a custom color for text color',
          (WidgetTester tester) async {
            await tester.pumpApp(
              MonthItem(
                name: ParamFactory.monthName,
                color: ParamFactory.textColor,
                onTap: () {},
              ),
            );

            final widget = find.byWidgetPredicate(
              (widget) => ParamFactory.isTextWithColor(
                widget,
                ParamFactory.textColor,
              ),
            );
            expect(widget, findsOneWidget);
          },
        );
        testWidgets(
          'FontWeight is different if [isSelected] is true or false',
          (WidgetTester tester) async {
            await tester.pumpApp(
              MonthItem(
                name: ParamFactory.monthName,
                isSelected: ParamFactory.isNotSelected, // default value
                onTap: () {},
              ),
            );

            var widget = find.byWidgetPredicate(
              (widget) => ParamFactory.isTextWithFontWeight(
                widget,
                FontWeight.w300,
              ),
            );
            expect(widget, findsOneWidget);

            await tester.pumpApp(
              MonthItem(
                name: ParamFactory.monthName,
                isSelected: ParamFactory.isSelected,
                onTap: () {},
              ),
            );

            widget = find.byWidgetPredicate(
              (widget) => ParamFactory.isTextWithFontWeight(
                widget,
                FontWeight.bold,
              ),
            );
            expect(widget, findsOneWidget);
          },
        );
      });
      group(
        'Call',
        () {
          testWidgets(
            '[onTap] callback when is tapped',
            (WidgetTester tester) async {
              var functionCalls = 0;
              final onTap = () => functionCalls++;

              await tester.pumpApp(
                MonthItem(
                  name: ParamFactory.monthName,
                  isSelected: ParamFactory.isSelected,
                  onTap: onTap,
                ),
              );

              expect(functionCalls, isZero);

              final widget = find.text(ParamFactory.monthName.toUpperCase());
              await tester.tap(widget);

              expect(functionCalls, 1);
            },
          );
        },
      );
    },
  );
}
