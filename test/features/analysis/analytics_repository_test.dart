import 'package:flutter_test/flutter_test.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/practice_session.dart';
import 'package:sgs_golf/data/models/shot.dart';
import 'package:sgs_golf/data/repositories/analytics_repository.dart';

void main() {
  test('countShotsForClub returns correct count for a club', () {
    final repo = AnalyticsRepository();
    final session = PracticeSession(
      date: DateTime(2025, 7, 9),
      duration: const Duration(minutes: 30),
      shots: [
        Shot(
          clubType: GolfClubType.pw,
          distance: 60,
          timestamp: DateTime(2025, 7, 9, 10),
        ),
        Shot(
          clubType: GolfClubType.pw,
          distance: 70,
          timestamp: DateTime(2025, 7, 9, 10, 5),
        ),
        Shot(
          clubType: GolfClubType.gw,
          distance: 55,
          timestamp: DateTime(2025, 7, 9, 10, 10),
        ),
      ],
      summary: '',
    );
    expect(repo.countShotsForClub(session, GolfClubType.pw), 2);
    expect(repo.countShotsForClub(session, GolfClubType.gw), 1);
    expect(repo.countShotsForClub(session, GolfClubType.sw), 0);
  });

  test('averageDistanceForClub returns correct average for a club', () {
    final repo = AnalyticsRepository();
    final session = PracticeSession(
      date: DateTime(2025, 7, 9),
      duration: const Duration(minutes: 30),
      shots: [
        Shot(
          clubType: GolfClubType.pw,
          distance: 60,
          timestamp: DateTime(2025, 7, 9, 10),
        ),
        Shot(
          clubType: GolfClubType.pw,
          distance: 70,
          timestamp: DateTime(2025, 7, 9, 10, 5),
        ),
        Shot(
          clubType: GolfClubType.gw,
          distance: 55,
          timestamp: DateTime(2025, 7, 9, 10, 10),
        ),
      ],
      summary: '',
    );
    expect(
      repo.averageDistanceForClub(session, GolfClubType.pw),
      closeTo(65, 0.01),
    );
    expect(repo.averageDistanceForClub(session, GolfClubType.gw), 55);
    expect(repo.averageDistanceForClub(session, GolfClubType.sw), 0);
  });
  group('AnalyticsRepository', () {
    final repo = AnalyticsRepository();
    final session = PracticeSession(
      date: DateTime(2025, 7, 9),
      duration: const Duration(minutes: 30),
      shots: [
        Shot(
          clubType: GolfClubType.pw,
          distance: 60,
          timestamp: DateTime(2025, 7, 9, 10),
        ),
        Shot(
          clubType: GolfClubType.pw,
          distance: 70,
          timestamp: DateTime(2025, 7, 9, 10, 5),
        ),
        Shot(
          clubType: GolfClubType.gw,
          distance: 55,
          timestamp: DateTime(2025, 7, 9, 10, 10),
        ),
      ],
      summary: '',
    );

    test('countByClub returns correct counts', () {
      final counts = repo.countByClub(session);
      expect(counts[GolfClubType.pw], 2);
      expect(counts[GolfClubType.gw], 1);
      expect(counts[GolfClubType.sw], 0);
    });

    test('sessionStats returns correct summary', () {
      final stats = repo.sessionStats(session);
      expect(stats[GolfClubType.pw]!['count'], 2);
      expect(stats[GolfClubType.pw]!['average'], closeTo(65, 0.01));
      expect(stats[GolfClubType.gw]!['count'], 1);
      expect(stats[GolfClubType.gw]!['average'], 55);
      expect(stats[GolfClubType.sw]!['count'], 0);
      expect(stats[GolfClubType.sw]!['average'], 0);
    });
    group('AnalyticsRepository', () {
      final repo = AnalyticsRepository();
      final session = PracticeSession(
        date: DateTime(2025, 7, 9),
        duration: const Duration(minutes: 30),
        shots: [
          Shot(
            clubType: GolfClubType.pw,
            distance: 60,
            timestamp: DateTime(2025, 7, 9, 10),
          ),
          Shot(
            clubType: GolfClubType.pw,
            distance: 70,
            timestamp: DateTime(2025, 7, 9, 10, 5),
          ),
          Shot(
            clubType: GolfClubType.gw,
            distance: 55,
            timestamp: DateTime(2025, 7, 9, 10, 10),
          ),
        ],
        summary: '',
      );

      test('averageDistanceByClub returns correct averages', () {
        final avg = repo.averageDistanceByClub(session);
        expect(avg[GolfClubType.pw], closeTo(65, 0.01));
        expect(avg[GolfClubType.gw], 55);
        expect(avg[GolfClubType.sw], 0);
      });

      test('consistencyByClub returns correct stddev', () {
        final std = repo.consistencyByClub(session);
        expect(std[GolfClubType.pw], greaterThan(0));
        expect(std[GolfClubType.gw], 0);
      });

      test('compareAverageByClub returns difference', () {
        final session2 = PracticeSession(
          date: DateTime(2025, 7, 8),
          duration: const Duration(minutes: 20),
          shots: [
            Shot(
              clubType: GolfClubType.pw,
              distance: 50,
              timestamp: DateTime(2025, 7, 8, 10),
            ),
          ],
          summary: '',
        );
        final diff = repo.compareAverageByClub(session, session2);
        expect(diff[GolfClubType.pw], 65 - 50);
      });
    });
  });
}
