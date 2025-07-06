import 'package:flutter_test/flutter_test.dart';
import 'package:sgs_golf/shared/utils/date_utils.dart';

void main() {
  group('DateUtilsShared', () {
    test('formatDate should format the date correctly', () {
      final date = DateTime(2025, 7, 6);
      expect(DateUtilsShared.formatDate(date), '06/07/2025');
    });

    test('formatDate should pad day and month with leading zeros', () {
      final date = DateTime(2025);
      expect(DateUtilsShared.formatDate(date), '01/01/2025');
    });
  });
}
