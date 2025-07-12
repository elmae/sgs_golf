import 'package:flutter_test/flutter_test.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/practice_session.dart';
import 'package:sgs_golf/data/models/shot.dart';
import 'package:sgs_golf/data/repositories/analytics_repository.dart';

void main() {
  late AnalyticsRepository repository;
  late PracticeSession emptySession;
  late PracticeSession typicalSession;
  late PracticeSession extremeSession;

  setUp(() {
    repository = AnalyticsRepository();

    // Sesión sin tiros (caso de datos vacíos)
    emptySession = PracticeSession(
      date: DateTime(2025, 7, 9),
      duration: const Duration(),
      shots: [],
      summary: 'Sesión vacía',
    );

    // Sesión con datos típicos
    typicalSession = PracticeSession(
      date: DateTime(2025, 7, 9),
      duration: const Duration(minutes: 45),
      shots: [
        Shot(
          clubType: GolfClubType.pw,
          distance: 60,
          timestamp: DateTime(2025, 7, 9, 10),
        ),
        Shot(
          clubType: GolfClubType.pw,
          distance: 65,
          timestamp: DateTime(2025, 7, 9, 10, 5),
        ),
        Shot(
          clubType: GolfClubType.pw,
          distance: 70,
          timestamp: DateTime(2025, 7, 9, 10, 10),
        ),
        Shot(
          clubType: GolfClubType.gw,
          distance: 50,
          timestamp: DateTime(2025, 7, 9, 10, 15),
        ),
        Shot(
          clubType: GolfClubType.gw,
          distance: 55,
          timestamp: DateTime(2025, 7, 9, 10, 20),
        ),
        Shot(
          clubType: GolfClubType.sw,
          distance: 40,
          timestamp: DateTime(2025, 7, 9, 10, 25),
        ),
      ],
      summary: 'Sesión típica con múltiples palos',
    );

    // Sesión con valores extremos
    extremeSession = PracticeSession(
      date: DateTime(2025, 7, 9),
      duration: const Duration(minutes: 60),
      shots: [
        Shot(
          clubType: GolfClubType.pw,
          distance: 0.1, // Valor mínimo extremo
          timestamp: DateTime(2025, 7, 9, 11),
        ),
        Shot(
          clubType: GolfClubType.pw,
          distance: 999.9, // Valor máximo extremo
          timestamp: DateTime(2025, 7, 9, 11, 5),
        ),
        Shot(
          clubType: GolfClubType.gw,
          distance: 0.1,
          timestamp: DateTime(2025, 7, 9, 11, 10),
        ),
        Shot(
          clubType: GolfClubType.gw,
          distance: 999.9,
          timestamp: DateTime(2025, 7, 9, 11, 15),
        ),
      ],
      summary: 'Sesión con valores extremos',
    );
  });

  group('countShotsForClub - Conteo de tiros por palo', () {
    test('debe devolver 0 para una sesión vacía', () {
      for (var clubType in GolfClubType.values) {
        expect(repository.countShotsForClub(emptySession, clubType), 0);
      }
    });

    test('debe contar correctamente para datos típicos', () {
      expect(repository.countShotsForClub(typicalSession, GolfClubType.pw), 3);
      expect(repository.countShotsForClub(typicalSession, GolfClubType.gw), 2);
      expect(repository.countShotsForClub(typicalSession, GolfClubType.sw), 1);
      expect(repository.countShotsForClub(typicalSession, GolfClubType.lw), 0);
    });

    test('debe manejar correctamente valores extremos', () {
      expect(repository.countShotsForClub(extremeSession, GolfClubType.pw), 2);
      expect(repository.countShotsForClub(extremeSession, GolfClubType.gw), 2);
      expect(repository.countShotsForClub(extremeSession, GolfClubType.sw), 0);
    });
  });

  group('averageDistanceForClub - Promedio de distancia por palo', () {
    test('debe devolver 0 para una sesión vacía', () {
      for (var clubType in GolfClubType.values) {
        expect(repository.averageDistanceForClub(emptySession, clubType), 0);
      }
    });

    test('debe devolver 0 cuando no hay tiros para un palo específico', () {
      expect(
        repository.averageDistanceForClub(typicalSession, GolfClubType.lw),
        0,
      );
    });

    test('debe calcular correctamente el promedio para datos típicos', () {
      // PW tiene tiros de 60, 65, 70 -> promedio de 65
      expect(
        repository.averageDistanceForClub(typicalSession, GolfClubType.pw),
        closeTo(65, 0.01),
      );

      // GW tiene tiros de 50, 55 -> promedio de 52.5
      expect(
        repository.averageDistanceForClub(typicalSession, GolfClubType.gw),
        closeTo(52.5, 0.01),
      );

      // SW tiene un solo tiro de 40
      expect(
        repository.averageDistanceForClub(typicalSession, GolfClubType.sw),
        40,
      );
    });

    test('debe manejar correctamente valores extremos', () {
      // PW tiene tiros de 0.1 y 999.9 -> promedio de 500
      expect(
        repository.averageDistanceForClub(extremeSession, GolfClubType.pw),
        closeTo(500, 0.01),
      );

      // GW también tiene tiros de 0.1 y 999.9
      expect(
        repository.averageDistanceForClub(extremeSession, GolfClubType.gw),
        closeTo(500, 0.01),
      );
    });
  });

  group('countByClub - Conteo por palo', () {
    test('debe devolver 0 para todos los palos en una sesión vacía', () {
      final counts = repository.countByClub(emptySession);
      for (var clubType in GolfClubType.values) {
        expect(counts[clubType], 0);
      }
    });

    test('debe contar correctamente para datos típicos', () {
      final counts = repository.countByClub(typicalSession);
      expect(counts[GolfClubType.pw], 3);
      expect(counts[GolfClubType.gw], 2);
      expect(counts[GolfClubType.sw], 1);
      expect(counts[GolfClubType.lw], 0);
    });

    test('debe manejar correctamente valores extremos', () {
      final counts = repository.countByClub(extremeSession);
      expect(counts[GolfClubType.pw], 2);
      expect(counts[GolfClubType.gw], 2);
      expect(counts[GolfClubType.sw], 0);
      expect(counts[GolfClubType.lw], 0);
    });
  });

  group('sessionStats - Estadísticas de sesión', () {
    test('debe devolver valores cero para una sesión vacía', () {
      final stats = repository.sessionStats(emptySession);
      for (var clubType in GolfClubType.values) {
        expect(stats[clubType]!['count'], 0);
        expect(stats[clubType]!['average'], 0);
      }
    });

    test('debe calcular correctamente las estadísticas para datos típicos', () {
      final stats = repository.sessionStats(typicalSession);

      // Validación para PW
      expect(stats[GolfClubType.pw]!['count'], 3);
      expect(stats[GolfClubType.pw]!['average'], closeTo(65, 0.01));

      // Validación para GW
      expect(stats[GolfClubType.gw]!['count'], 2);
      expect(stats[GolfClubType.gw]!['average'], closeTo(52.5, 0.01));

      // Validación para SW
      expect(stats[GolfClubType.sw]!['count'], 1);
      expect(stats[GolfClubType.sw]!['average'], 40);

      // Validación para LW (sin tiros)
      expect(stats[GolfClubType.lw]!['count'], 0);
      expect(stats[GolfClubType.lw]!['average'], 0);
    });

    test('debe manejar correctamente valores extremos', () {
      final stats = repository.sessionStats(extremeSession);

      // Validación para PW con valores extremos
      expect(stats[GolfClubType.pw]!['count'], 2);
      expect(stats[GolfClubType.pw]!['average'], closeTo(500, 0.01));

      // Validación para GW con valores extremos
      expect(stats[GolfClubType.gw]!['count'], 2);
      expect(stats[GolfClubType.gw]!['average'], closeTo(500, 0.01));
    });
  });

  group('averageDistanceByClub - Promedio de distancia por palo', () {
    test('debe devolver cero para todos los palos en una sesión vacía', () {
      final averages = repository.averageDistanceByClub(emptySession);
      for (var clubType in GolfClubType.values) {
        expect(averages[clubType], 0);
      }
    });

    test('debe calcular correctamente los promedios para datos típicos', () {
      final averages = repository.averageDistanceByClub(typicalSession);
      expect(averages[GolfClubType.pw], closeTo(65, 0.01));
      expect(averages[GolfClubType.gw], closeTo(52.5, 0.01));
      expect(averages[GolfClubType.sw], 40);
      expect(averages[GolfClubType.lw], 0);
    });

    test('debe manejar correctamente valores extremos', () {
      final averages = repository.averageDistanceByClub(extremeSession);
      expect(averages[GolfClubType.pw], closeTo(500, 0.01));
      expect(averages[GolfClubType.gw], closeTo(500, 0.01));
    });
  });

  group('consistencyByClub - Desviación estándar por palo', () {
    test('debe devolver cero para todos los palos en una sesión vacía', () {
      final consistency = repository.consistencyByClub(emptySession);
      for (var clubType in GolfClubType.values) {
        expect(consistency[clubType], 0);
      }
    });

    test('debe devolver cero cuando hay menos de 2 tiros para un palo', () {
      final consistency = repository.consistencyByClub(typicalSession);
      expect(consistency[GolfClubType.sw], 0); // Solo 1 tiro
      expect(consistency[GolfClubType.lw], 0); // 0 tiros
    });

    test('debe calcular correctamente la consistencia para datos típicos', () {
      final consistency = repository.consistencyByClub(typicalSession);

      // Para PW con distancias [60, 65, 70], desviación estándar esperada ~ 5
      expect(consistency[GolfClubType.pw], closeTo(5, 0.1));

      // Para GW con distancias [50, 55], desviación estándar esperada ~ 3.54
      expect(consistency[GolfClubType.gw], closeTo(3.54, 0.1));
    });

    test('debe manejar correctamente valores extremos', () {
      final consistency = repository.consistencyByClub(extremeSession);

      // Para PW con distancias [0.1, 999.9], desviación estándar esperada muy alta
      expect(consistency[GolfClubType.pw], greaterThan(700));

      // Para GW con distancias [0.1, 999.9], similar
      expect(consistency[GolfClubType.gw], greaterThan(700));
    });
  });

  group('compareAverageByClub - Comparación de promedios entre sesiones', () {
    test('debe devolver cero cuando ambas sesiones están vacías', () {
      final emptySession2 = PracticeSession(
        date: DateTime(2025, 7, 10),
        duration: const Duration(),
        shots: [],
        summary: 'Otra sesión vacía',
      );

      final comparison = repository.compareAverageByClub(
        emptySession,
        emptySession2,
      );
      for (var clubType in GolfClubType.values) {
        expect(comparison[clubType], 0);
      }
    });

    test('debe calcular correctamente las diferencias para datos típicos', () {
      final otherSession = PracticeSession(
        date: DateTime(2025, 7, 10),
        duration: const Duration(minutes: 30),
        shots: [
          Shot(
            clubType: GolfClubType.pw,
            distance: 75,
            timestamp: DateTime(2025, 7, 10, 10),
          ),
          Shot(
            clubType: GolfClubType.sw,
            distance: 35,
            timestamp: DateTime(2025, 7, 10, 10, 5),
          ),
        ],
        summary: 'Otra sesión típica',
      );

      final comparison = repository.compareAverageByClub(
        typicalSession,
        otherSession,
      );

      // PW: típica (65) vs otra (75) = -10
      expect(comparison[GolfClubType.pw], closeTo(-10, 0.01));

      // GW: típica (52.5) vs otra (0) = 52.5
      expect(comparison[GolfClubType.gw], closeTo(52.5, 0.01));

      // SW: típica (40) vs otra (35) = 5
      expect(comparison[GolfClubType.sw], closeTo(5, 0.01));

      // LW: típica (0) vs otra (0) = 0
      expect(comparison[GolfClubType.lw], 0);
    });

    test('debe manejar correctamente valores extremos y sesión vacía', () {
      final comparison = repository.compareAverageByClub(
        extremeSession,
        emptySession,
      );

      // PW: extrema (500) vs vacía (0) = 500
      expect(comparison[GolfClubType.pw], closeTo(500, 0.01));

      // GW: extrema (500) vs vacía (0) = 500
      expect(comparison[GolfClubType.gw], closeTo(500, 0.01));
    });
  });
}
