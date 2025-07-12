import 'package:flutter_test/flutter_test.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/session_statistics.dart';
import 'package:sgs_golf/data/models/session_statistics_ext.dart';

void main() {
  group('SessionStatistics Extension Tests', () {
    late SessionStatistics stats;

    setUp(() {
      // Crear una instancia de estadísticas con datos simulados
      final shotCounts = {
        GolfClubType.pw: 15,
        GolfClubType.gw: 10,
        GolfClubType.sw: 20,
        GolfClubType.lw: 5,
      };

      final totalDistanceByClub = {
        GolfClubType.pw: 1500.0, // 100 metros promedio
        GolfClubType.gw: 850.0, // 85 metros promedio
        GolfClubType.sw: 1400.0, // 70 metros promedio
        GolfClubType.lw: 275.0, // 55 metros promedio
      };

      final averageDistanceByClub = {
        GolfClubType.pw: 100.0,
        GolfClubType.gw: 85.0,
        GolfClubType.sw: 70.0,
        GolfClubType.lw: 55.0,
      };

      stats = SessionStatistics(
        totalShots: 50,
        totalDistance: 4025.0,
        averageDistance: 80.5,
        shotCounts: shotCounts,
        totalDistanceByClub: totalDistanceByClub,
        averageDistanceByClub: averageDistanceByClub,
        durationInMinutes: 60.0,
        shotsPerMinute: 0.83,
      );
    });

    test('getMostUsedClubType returns correct club', () {
      expect(stats.getMostUsedClubType(), GolfClubType.sw);
    });

    test('getLongestClubType returns correct club', () {
      expect(stats.getLongestClubType(), GolfClubType.pw);
    });

    test('hasShotsForClub returns correct value', () {
      expect(stats.hasShotsForClub(GolfClubType.pw), true);
      expect(stats.hasShotsForClub(GolfClubType.sw), true);

      // Caso donde no hay tiros
      final emptyStats = SessionStatistics.empty();
      expect(emptyStats.hasShotsForClub(GolfClubType.pw), false);
    });

    test('clubUsagePercentage calculates correctly', () {
      final percentages = stats.clubUsagePercentage;

      // PW: 15/50 = 30%
      expect(percentages[GolfClubType.pw], 30.0);

      // SW: 20/50 = 40%
      expect(percentages[GolfClubType.sw], 40.0);

      // LW: 5/50 = 10%
      expect(percentages[GolfClubType.lw], 10.0);
    });

    test('formattedDuration shows correct format', () {
      expect(stats.formattedDuration, '1h 0m 0s');

      final shortStats = SessionStatistics(
        totalShots: 1,
        totalDistance: 100,
        averageDistance: 100,
        shotCounts: {for (final club in GolfClubType.values) club: 0},
        totalDistanceByClub: {
          for (final club in GolfClubType.values) club: 0.0,
        },
        averageDistanceByClub: {
          for (final club in GolfClubType.values) club: 0.0,
        },
        durationInMinutes: 3.5,
      );

      expect(shortStats.formattedDuration, '3m 30s');
    });

    test('overallConsistency calculation', () {
      expect(stats.overallConsistency, isNotNull);
      expect(stats.overallConsistency, greaterThanOrEqualTo(0.0));
      expect(stats.overallConsistency, lessThanOrEqualTo(100.0));
    });

    test('consistencyByClub returns values for all clubs', () {
      final consistencies = stats.consistencyByClub;

      for (final club in GolfClubType.values) {
        expect(consistencies[club], isNotNull);
        expect(consistencies[club], greaterThanOrEqualTo(0.0));
        expect(consistencies[club], lessThanOrEqualTo(100.0));
      }
    });

    test('distanceImprovement compares sessions correctly', () {
      final olderStats = SessionStatistics(
        totalShots: 40,
        totalDistance: 3000.0,
        averageDistance: 75.0,
        shotCounts: {for (final club in GolfClubType.values) club: 10},
        totalDistanceByClub: {
          for (final club in GolfClubType.values) club: 750.0,
        },
        averageDistanceByClub: {
          for (final club in GolfClubType.values) club: 75.0,
        },
        durationInMinutes: 50.0,
      );

      // Comparamos (80.5 - 75.0) / 75.0 * 100 = 7.33%
      final improvement = stats.distanceImprovement(olderStats);
      expect(improvement, closeTo(7.33, 0.1));
    });

    test('improvementSummary shows formatted improvement text', () {
      final olderStats = SessionStatistics(
        totalShots: 40,
        totalDistance: 3000.0,
        averageDistance: 75.0,
        shotCounts: {for (final club in GolfClubType.values) club: 10},
        totalDistanceByClub: {
          for (final club in GolfClubType.values) club: 750.0,
        },
        averageDistanceByClub: {
          for (final club in GolfClubType.values) club: 75.0,
        },
        durationInMinutes: 50.0,
      );

      final summary = stats.improvementSummary(olderStats);
      expect(summary.contains('+'), isTrue); // Debe mostrar mejora
      expect(summary.contains('Distancia'), isTrue);
      expect(summary.contains('Tiros'), isTrue);
    });
  });
}
