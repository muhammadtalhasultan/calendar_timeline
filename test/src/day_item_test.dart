import 'package:flutter_test/flutter_test.dart';
import 'package:calendar_timeline/calendar_timeline.dart';

import '../helper/helper.dart';
import '../test_utils/test_utils.dart';

void main() {
  group(
    'DayItem',
    () {
      group(
        'Render',
        () {
          testWidgets(
            'a day and a name texts',
            (WidgetTester tester) async {
              await tester.pumpApp(
                DayItem(
                  dayNumber: ParamFactory.dayNumber,
                  shortName: ParamFactory.dayName,
                  isSelected: true,
                  onTap: () {},
                ),
              );

              final day = find.text(ParamFactory.dayNumber.toString());
              final name = find.text(ParamFactory.dayName);
              expect(day, findsOneWidget);
              expect(name, findsOneWidget);
            },
          );
        },
      );
      group(
        'Style',
        () {
          testWidgets(
            'background color change according to [isSelected] value',
            (WidgetTester tester) async {
              await tester.pumpApp(
                DayItem(
                  dayNumber: ParamFactory.dayNumber,
                  shortName: ParamFactory.dayName,
                  activeDayBackgroundColor: ParamFactory.activeColor,
                  onTap: () {},
                ),
              );

              var foundWidget = find.byWidgetPredicate(
                (widget) => ParamFactory.isContainerWithColor(
                  widget,
                  ParamFactory.activeColor,
                ),
              );

              expect(foundWidget, findsNothing);

              await tester.pumpApp(
                DayItem(
                  dayNumber: ParamFactory.dayNumber,
                  shortName: ParamFactory.dayName,
                  activeDayBackgroundColor: ParamFactory.activeColor,
                  isSelected: true,
                  onTap: () {},
                ),
              );

              foundWidget = find.byWidgetPredicate(
                (widget) => ParamFactory.isContainerWithColor(
                  widget,
                  ParamFactory.activeColor,
                ),
              );

              expect(foundWidget, findsOneWidget);
            },
          );
          testWidgets(
            'font color changes according to [isSelected] value',
            (WidgetTester tester) async {
              await tester.pumpApp(
                DayItem(
                  dayNumber: ParamFactory.dayNumber,
                  shortName: ParamFactory.dayName,
                  activeDayColor: ParamFactory.activeColor,
                  onTap: () {},
                ),
              );

              var foundWidget = find.byWidgetPredicate(
                (widget) => ParamFactory.isTextWithColor(
                  widget,
                  ParamFactory.activeColor,
                ),
              );

              expect(foundWidget, findsNothing);

              await tester.pumpApp(
                DayItem(
                  dayNumber: ParamFactory.dayNumber,
                  shortName: ParamFactory.dayName,
                  activeDayColor: ParamFactory.activeColor,
                  isSelected: true,
                  onTap: () {},
                ),
              );

              foundWidget = find.byWidgetPredicate(
                (widget) => ParamFactory.isTextWithColor(
                  widget,
                  ParamFactory.activeColor,
                ),
              );

              // in this case, we find 2 widgets because day and name day have
              // the same color. However, we can customize day name color.
              expect(foundWidget, findsNWidgets(2));
            },
          );
        },
      );
    },
  );
}
