import 'dart:math';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/practice_session.dart';

class AnalyticsRepository {
  /// Devuelve el conteo de tiros para un tipo de palo específico en una sesión
  int countShotsForClub(PracticeSession session, GolfClubType clubType) {
    return session.shots.where((s) => s.clubType == clubType).length;
  }

  /// Devuelve el promedio de distancia para un tipo de palo específico en una sesión
  double averageDistanceForClub(
    PracticeSession session,
    GolfClubType clubType,
  ) {
    final clubShots = session.shots
        .where((s) => s.clubType == clubType)
        .toList();
    if (clubShots.isEmpty) return 0;
    return clubShots.map((s) => s.distance).reduce((a, b) => a + b) /
        clubShots.length;
  }

  /// Cuenta la cantidad de tiros por tipo de palo para una sesión
  Map<GolfClubType, int> countByClub(PracticeSession session) {
    final result = <GolfClubType, int>{};
    for (var club in GolfClubType.values) {
      result[club] = session.shots.where((s) => s.clubType == club).length;
    }
    return result;
  }

  /// Devuelve un resumen de estadísticas por sesión: conteo y promedio por palo
  Map<GolfClubType, Map<String, num>> sessionStats(PracticeSession session) {
    final stats = <GolfClubType, Map<String, num>>{};
    final avg = averageDistanceByClub(session);
    final count = countByClub(session);
    for (var club in GolfClubType.values) {
      stats[club] = {'count': count[club] ?? 0, 'average': avg[club] ?? 0};
    }
    return stats;
  }

  /// Calcula el promedio de distancia por palo para una sesión
  Map<GolfClubType, double> averageDistanceByClub(PracticeSession session) {
    final result = <GolfClubType, double>{};
    for (var club in GolfClubType.values) {
      final clubShots = session.shots.where((s) => s.clubType == club).toList();
      if (clubShots.isNotEmpty) {
        result[club] =
            clubShots.map((s) => s.distance).reduce((a, b) => a + b) /
            clubShots.length;
      } else {
        result[club] = 0;
      }
    }
    return result;
  }

  /// Calcula la desviación estándar (consistencia) por palo para una sesión
  Map<GolfClubType, double> consistencyByClub(PracticeSession session) {
    final result = <GolfClubType, double>{};
    for (var club in GolfClubType.values) {
      final clubShots = session.shots.where((s) => s.clubType == club).toList();
      if (clubShots.length > 1) {
        final avg =
            clubShots.map((s) => s.distance).reduce((a, b) => a + b) /
            clubShots.length;
        final variance =
            clubShots
                .map((s) => pow(s.distance - avg, 2))
                .reduce((a, b) => a + b) /
            (clubShots.length - 1);
        result[club] = sqrt(variance);
      } else {
        result[club] = 0;
      }
    }
    return result;
  }

  /// Compara el promedio de distancia por palo entre dos sesiones
  Map<GolfClubType, double> compareAverageByClub(
    PracticeSession a,
    PracticeSession b,
  ) {
    final avgA = averageDistanceByClub(a);
    final avgB = averageDistanceByClub(b);
    final result = <GolfClubType, double>{};
    for (var club in GolfClubType.values) {
      result[club] = (avgA[club] ?? 0) - (avgB[club] ?? 0);
    }
    return result;
  }
}
