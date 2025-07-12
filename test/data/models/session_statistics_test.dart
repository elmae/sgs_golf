import 'package:flutter_test/flutter_test.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/session_statistics.dart';

void main() {
  group('SessionStatistics Tests', () {
    test('SessionStatistics.empty() should create empty statistics', () {
      final stats = SessionStatistics.empty();
      expect(stats.totalShots, 0);
      expect(stats.totalDistance, 0.0);
      expect(stats.averageDistance, 0.0);
      expect(stats.durationInMinutes, 0.0);
      expect(stats.shotsPerMinute, null);

      // Verificar mapas para cada tipo de palo
      for (final club in GolfClubType.values) {
        expect(stats.shotCounts[club], 0);
        expect(stats.totalDistanceByClub[club], 0.0);
        expect(stats.averageDistanceByClub[club], 0.0);
      }
    });

    test('SessionStatistics constructor should set values correctly', () {
      final shotCounts = {for (final club in GolfClubType.values) club: 10};

      final totalDistanceByClub = {
        for (final club in GolfClubType.values) club: 1000.0,
      };

      final averageDistanceByClub = {
        for (final club in GolfClubType.values) club: 100.0,
      };

      final stats = SessionStatistics(
        totalShots: 40,
        totalDistance: 4000.0,
        averageDistance: 100.0,
        shotCounts: shotCounts,
        totalDistanceByClub: totalDistanceByClub,
        averageDistanceByClub: averageDistanceByClub,
        durationInMinutes: 60.0,
        shotsPerMinute: 0.67,
      );

      expect(stats.totalShots, 40);
      expect(stats.totalDistance, 4000.0);
      expect(stats.averageDistance, 100.0);
      expect(stats.durationInMinutes, 60.0);
      expect(stats.shotsPerMinute, 0.67);

      // Verificar mapas para cada tipo de palo
      for (final club in GolfClubType.values) {
        expect(stats.shotCounts[club], 10);
        expect(stats.totalDistanceByClub[club], 1000.0);
        expect(stats.averageDistanceByClub[club], 100.0);
      }
    });

    test('hasShotsForClub should return true only for clubs with shots', () {
      final shotCounts = {
        GolfClubType.pw: 5,
        GolfClubType.gw: 0,
        GolfClubType.sw: 3,
        GolfClubType.lw: 0,
      };

      final stats = SessionStatistics(
        totalShots: 8,
        totalDistance: 800.0,
        averageDistance: 100.0,
        shotCounts: shotCounts,
        totalDistanceByClub: {
          for (final club in GolfClubType.values) club: 0.0,
        },
        averageDistanceByClub: {
          for (final club in GolfClubType.values) club: 0.0,
        },
        durationInMinutes: 30.0,
        shotsPerMinute: 0.27,
      );

      expect(stats.hasShotsForClub(GolfClubType.pw), true);
      expect(stats.hasShotsForClub(GolfClubType.gw), false);
      expect(stats.hasShotsForClub(GolfClubType.sw), true);
      expect(stats.hasShotsForClub(GolfClubType.lw), false);
    });

    test(
      'getLongestClubType should return club with highest average distance',
      () {
        final stats = SessionStatistics(
          totalShots: 15,
          totalDistance: 1450.0,
          averageDistance: 96.67,
          shotCounts: {
            GolfClubType.pw: 5,
            GolfClubType.gw: 3,
            GolfClubType.sw: 7,
            GolfClubType.lw: 0,
          },
          totalDistanceByClub: {
            GolfClubType.pw: 500.0,
            GolfClubType.gw: 450.0,
            GolfClubType.sw: 500.0,
            GolfClubType.lw: 0.0,
          },
          averageDistanceByClub: {
            GolfClubType.pw: 100.0,
            GolfClubType.gw: 150.0, // El más largo
            GolfClubType.sw: 71.43,
            GolfClubType.lw: 0.0,
          },
          durationInMinutes: 45.0,
          shotsPerMinute: 0.33,
        );

        expect(stats.getLongestClubType(), equals(GolfClubType.gw));
      },
    );

    test('getMostUsedClubType should return club with highest shot count', () {
      final stats = SessionStatistics(
        totalShots: 20,
        totalDistance: 2000.0,
        averageDistance: 100.0,
        shotCounts: {
          GolfClubType.pw: 5,
          GolfClubType.gw: 3,
          GolfClubType.sw: 12, // El más usado
          GolfClubType.lw: 0,
        },
        totalDistanceByClub: {
          for (final club in GolfClubType.values) club: 0.0,
        },
        averageDistanceByClub: {
          for (final club in GolfClubType.values) club: 0.0,
        },
        durationInMinutes: 50.0,
        shotsPerMinute: 0.4,
      );

      expect(stats.getMostUsedClubType(), equals(GolfClubType.sw));
    });

    test(
      'getMostEfficientClubType should return club with best distance/effort ratio',
      () {
        final stats = SessionStatistics(
          totalShots: 15,
          totalDistance: 1450.0,
          averageDistance: 96.67,
          shotCounts: {
            GolfClubType.pw: 5,
            GolfClubType.gw: 2, // Menor esfuerzo para buena distancia
            GolfClubType.sw: 8,
            GolfClubType.lw: 0,
          },
          totalDistanceByClub: {
            GolfClubType.pw: 500.0,
            GolfClubType.gw: 300.0,
            GolfClubType.sw: 650.0,
            GolfClubType.lw: 0.0,
          },
          averageDistanceByClub: {
            GolfClubType.pw: 100.0,
            GolfClubType.gw: 150.0, // Mayor eficiencia (150/2 = 75)
            GolfClubType.sw: 81.25, // (81.25/8 = 10.16)
            GolfClubType.lw: 0.0,
          },
          durationInMinutes: 45.0,
          shotsPerMinute: 0.33,
        );

        expect(stats.getMostEfficientClubType(), equals(GolfClubType.gw));
      },
    );

    test('improvementTrend should return a value between -1.0 and 1.0', () {
      final statsWithFewShots = SessionStatistics(
        totalShots: 3, // Menos de 5 tiros
        totalDistance: 300.0,
        averageDistance: 100.0,
        shotCounts: {for (final club in GolfClubType.values) club: 0},
        totalDistanceByClub: {
          for (final club in GolfClubType.values) club: 0.0,
        },
        averageDistanceByClub: {
          for (final club in GolfClubType.values) club: 0.0,
        },
        durationInMinutes: 10.0,
        shotsPerMinute: 0.3,
      );

      final statsWithManyShots = SessionStatistics(
        totalShots: 10,
        totalDistance: 1000.0,
        averageDistance: 100.0,
        shotCounts: {for (final club in GolfClubType.values) club: 0},
        totalDistanceByClub: {
          for (final club in GolfClubType.values) club: 0.0,
        },
        averageDistanceByClub: {
          for (final club in GolfClubType.values) club: 0.0,
        },
        durationInMinutes: 30.0,
        shotsPerMinute: 0.33,
      );

      // Para pocos tiros, la tendencia debe ser 0
      expect(statsWithFewShots.improvementTrend, equals(0.0));

      // Para suficientes tiros, debe estar en el rango [-1.0, 1.0]
      expect(statsWithManyShots.improvementTrend, inClosedOpenRange(-1.0, 1.0));
    });

    test('performanceScore should return a score between 0 and 100', () {
      final emptyStats = SessionStatistics.empty();
      final goodStats = SessionStatistics(
        totalShots: 40,
        totalDistance: 4000.0,
        averageDistance: 100.0,
        shotCounts: {for (final club in GolfClubType.values) club: 10},
        totalDistanceByClub: {
          for (final club in GolfClubType.values) club: 1000.0,
        },
        averageDistanceByClub: {
          for (final club in GolfClubType.values) club: 100.0,
        },
        durationInMinutes: 60.0,
        shotsPerMinute: 0.67,
      );

      // Sin tiros, la puntuación debe ser 0
      expect(emptyStats.performanceScore, equals(0.0));

      // Con buenos datos, la puntuación debe ser > 0
      expect(goodStats.performanceScore, greaterThan(0.0));
      expect(goodStats.performanceScore, lessThanOrEqualTo(100.0));
    });

    test('formattedDuration should format duration correctly', () {
      final shortStats = SessionStatistics(
        totalShots: 5,
        totalDistance: 500.0,
        averageDistance: 100.0,
        shotCounts: {for (final club in GolfClubType.values) club: 0},
        totalDistanceByClub: {
          for (final club in GolfClubType.values) club: 0.0,
        },
        averageDistanceByClub: {
          for (final club in GolfClubType.values) club: 0.0,
        },
        durationInMinutes: 0.5, // 30 segundos
        shotsPerMinute: 10.0,
      );

      final mediumStats = SessionStatistics(
        totalShots: 20,
        totalDistance: 2000.0,
        averageDistance: 100.0,
        shotCounts: {for (final club in GolfClubType.values) club: 0},
        totalDistanceByClub: {
          for (final club in GolfClubType.values) club: 0.0,
        },
        averageDistanceByClub: {
          for (final club in GolfClubType.values) club: 0.0,
        },
        durationInMinutes: 25.0, // 25 minutos
        shotsPerMinute: 0.8,
      );

      final longStats = SessionStatistics(
        totalShots: 100,
        totalDistance: 10000.0,
        averageDistance: 100.0,
        shotCounts: {for (final club in GolfClubType.values) club: 0},
        totalDistanceByClub: {
          for (final club in GolfClubType.values) club: 0.0,
        },
        averageDistanceByClub: {
          for (final club in GolfClubType.values) club: 0.0,
        },
        durationInMinutes: 125.0, // 2h 5m
        shotsPerMinute: 0.8,
      );

      expect(shortStats.formattedDuration, equals('30s'));
      expect(mediumStats.formattedDuration, equals('25m 0s'));
      expect(longStats.formattedDuration, equals('2h 5m 0s'));
    });
  });
}
