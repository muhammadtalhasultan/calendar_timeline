import 'package:calendar_timeline/src/util/string_extension.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_utils/param_factory.dart';

void main() {
  test('String capitalize function would convert first character to uppercase',
      () {
    const string = ParamFactory.unCapitalizedString;
    expect(string.capitalize(), ParamFactory.capitalizedString);
  });
}
