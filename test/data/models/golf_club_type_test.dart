import 'package:flutter_test/flutter_test.dart';
import 'package:sgs_golf/data/models/golf_club.dart';

void main() {
  group('GolfClubType enum', () {
    test('should contain all wedge types', () {
      expect(GolfClubType.values.length, 4);
      expect(GolfClubType.pw.toString(), 'GolfClubType.pw');
      expect(GolfClubType.gw.toString(), 'GolfClubType.gw');
      expect(GolfClubType.sw.toString(), 'GolfClubType.sw');
      expect(GolfClubType.lw.toString(), 'GolfClubType.lw');
    });

    test('should have correct index for each type', () {
      expect(GolfClubType.pw.index, 0);
      expect(GolfClubType.gw.index, 1);
      expect(GolfClubType.sw.index, 2);
      expect(GolfClubType.lw.index, 3);
    });
  });
}
