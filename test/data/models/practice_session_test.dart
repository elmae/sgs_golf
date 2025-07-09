import 'package:flutter_test/flutter_test.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/practice_session.dart';
import 'package:sgs_golf/data/models/shot.dart';

void main() {
  group('PracticeSession model', () {
    test('should create a valid PracticeSession instance', () {
      final shots = [
        Shot(
          clubType: GolfClubType.pw,
          distance: 50,
          timestamp: DateTime(2025, 7, 8, 10),
        ),
        Shot(
          clubType: GolfClubType.sw,
          distance: 40,
          timestamp: DateTime(2025, 7, 8, 10, 5),
        ),
      ];
      final session = PracticeSession(
        date: DateTime(2025, 7, 8),
        duration: const Duration(minutes: 30),
        shots: shots,
        summary: '2 tiros, promedio 45m',
      );
      expect(session.date, DateTime(2025, 7, 8));
      expect(session.duration, const Duration(minutes: 30));
      expect(session.shots.length, 2);
      expect(session.summary, contains('promedio'));
    });

    test('totalShots and totalDistance getters', () {
      final shots = [
        Shot(
          clubType: GolfClubType.pw,
          distance: 60,
          timestamp: DateTime(2025, 7, 8, 10),
        ),
        Shot(
          clubType: GolfClubType.gw,
          distance: 55,
          timestamp: DateTime(2025, 7, 8, 10, 10),
        ),
      ];
      final session = PracticeSession(
        date: DateTime(2025, 7, 8),
        duration: const Duration(minutes: 20),
        shots: shots,
        summary: '2 tiros',
      );
      expect(session.totalShots, 2);
      expect(session.totalDistance, 115);
    });
  });
}
