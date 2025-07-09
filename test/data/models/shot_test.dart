import 'package:flutter_test/flutter_test.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/shot.dart';

void main() {
  group('Shot model', () {
    test('should create a valid Shot instance', () {
      final shot = Shot(
        clubType: GolfClubType.sw,
        distance: 45.5,
        timestamp: DateTime.parse('2025-07-08T10:00:00Z'),
      );
      expect(shot.clubType, GolfClubType.sw);
      expect(shot.distance, 45.5);
      expect(shot.timestamp, DateTime.parse('2025-07-08T10:00:00Z'));
    });

    test('toString returns expected format', () {
      final shot = Shot(
        clubType: GolfClubType.pw,
        distance: 60.0,
        timestamp: DateTime(2025, 7, 8, 12),
      );
      expect(shot.toString(), contains('clubType: GolfClubType.pw'));
      expect(shot.toString(), contains('distance: 60.0'));
    });
  });
}
