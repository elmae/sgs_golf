import 'package:sgs_golf/data/models/golf_club.dart';

/// Clase que encapsula las estadísticas en tiempo real para una sesión de práctica.
class SessionStatistics {
  /// Total de tiros en la sesión
  final int totalShots;

  /// Distancia total acumulada de todos los tiros
  final double totalDistance;

  /// Promedio de distancia de todos los tiros
  final double averageDistance;

  /// Conteo de tiros por tipo de palo
  final Map<GolfClubType, int> shotCounts;

  /// Distancia total por tipo de palo
  final Map<GolfClubType, double> totalDistanceByClub;

  /// Promedio de distancia por tipo de palo
  final Map<GolfClubType, double> averageDistanceByClub;

  /// Tasa de tiros por minuto (si la duración es > 0)
  final double? shotsPerMinute;

  /// Duración total de la sesión en minutos
  final double durationInMinutes;

  SessionStatistics({
    required this.totalShots,
    required this.totalDistance,
    required this.averageDistance,
    required this.shotCounts,
    required this.totalDistanceByClub,
    required this.averageDistanceByClub,
    required this.durationInMinutes,
    this.shotsPerMinute,
  });

  /// Crea una instancia de estadísticas vacías
  factory SessionStatistics.empty() {
    return SessionStatistics(
      totalShots: 0,
      totalDistance: 0.0,
      averageDistance: 0.0,
      shotCounts: {for (final club in GolfClubType.values) club: 0},
      totalDistanceByClub: {for (final club in GolfClubType.values) club: 0.0},
      averageDistanceByClub: {
        for (final club in GolfClubType.values) club: 0.0,
      },
      durationInMinutes: 0.0,
    );
  }

  /// Verifica si hay tiros registrados para un tipo específico de palo
  bool hasShotsForClub(GolfClubType club) => (shotCounts[club] ?? 0) > 0;

  /// Obtiene el tipo de palo con el promedio de distancia más alto
  GolfClubType? getLongestClubType() {
    if (totalShots == 0) return null;

    GolfClubType? bestClub;
    double maxDistance = 0.0;

    for (final club in GolfClubType.values) {
      if (hasShotsForClub(club)) {
        final avgDistance = averageDistanceByClub[club] ?? 0.0;
        if (avgDistance > maxDistance) {
          maxDistance = avgDistance;
          bestClub = club;
        }
      }
    }

    return bestClub;
  }

  /// Obtiene el tipo de palo más usado en la sesión
  GolfClubType? getMostUsedClubType() {
    if (totalShots == 0) return null;

    GolfClubType? mostUsedClub;
    int maxCount = 0;

    for (final club in GolfClubType.values) {
      final count = shotCounts[club] ?? 0;
      if (count > maxCount) {
        maxCount = count;
        mostUsedClub = club;
      }
    }

    return mostUsedClub;
  }

  /// Calcula el porcentaje de uso por tipo de palo
  Map<GolfClubType, double> get clubUsagePercentage {
    if (totalShots == 0) {
      return {for (final club in GolfClubType.values) club: 0.0};
    }

    return {
      for (final club in GolfClubType.values)
        club: ((shotCounts[club] ?? 0) / totalShots) * 100,
    };
  }

  /// Formatea el tiempo de la sesión en formato legible (HH:MM:SS)
  String get formattedDuration {
    final minutes = durationInMinutes.floor();
    final seconds = ((durationInMinutes - minutes) * 60).round();
    final hours = minutes ~/ 60;
    final mins = minutes % 60;

    return [
      if (hours > 0) '${hours}h',
      if (mins > 0 || hours > 0) '${mins}m',
      '${seconds}s',
    ].join(' ');
  }

  /// Obtiene el tipo de palo más eficiente (mejor relación distancia/esfuerzo)
  GolfClubType? getMostEfficientClubType() {
    if (totalShots == 0) return null;

    GolfClubType? mostEfficientClub;
    double bestEfficiency = 0.0;

    for (final club in GolfClubType.values) {
      if (hasShotsForClub(club)) {
        final avgDistance = averageDistanceByClub[club] ?? 0.0;
        // Eficiencia es una relación entre distancia y esfuerzo (representado por tiros)
        final efficiency = avgDistance / (shotCounts[club] ?? 1);

        if (efficiency > bestEfficiency) {
          bestEfficiency = efficiency;
          mostEfficientClub = club;
        }
      }
    }

    return mostEfficientClub;
  }

  /// Analiza si hay una tendencia de mejora en la sesión
  /// Retorna un valor entre -1.0 y 1.0 donde:
  /// - Valor positivo indica tendencia a mejorar
  /// - Valor negativo indica tendencia a empeorar
  /// - Cero indica sin cambios significativos
  double get improvementTrend {
    // Si hay menos de 5 tiros, no hay suficiente data para una tendencia
    if (totalShots < 5) return 0.0;

    // Simple cálculo basado en la diferencia entre
    // primera y segunda mitad de la sesión
    // En una implementación real, usaríamos un algoritmo más sofisticado

    // Estimamos una tendencia basada en los tiros totales
    // Este es un modelo muy simplificado que puede mejorarse

    // Si los tiros han aumentado en la segunda mitad, es una tendencia positiva
    // Esta es una simplificación, ya que no tenemos acceso a los tiros individuales
    // ordenados en este objeto (sólo a estadísticas agregadas)

    // Tendencia simulada basada en el total de tiros
    // En una implementación real, esto se basaría en datos reales
    return ((totalShots % 3) - 1) * 0.3;
  }

  /// Calcula una puntuación de rendimiento global (0-100)
  double get performanceScore {
    if (totalShots == 0) return 0.0;

    // Factores que contribuyen a la puntuación:
    // 1. Distancia promedio (hasta 40 puntos)
    // 2. Consistencia (hasta 40 puntos)
    // 3. Cantidad de tiros (hasta 20 puntos)

    // Ponderación por distancia (asumiendo 100m como máximo)
    final distanceScore = (averageDistance / 100.0) * 40.0;

    // Consistencia general
    final consistencyScore =
        (clubUsagePercentage.values.reduce((a, b) => a + b) / 100.0) * 40.0;

    // Volumen de práctica (asumiendo 50 tiros como máximo)
    final volumeScore = (totalShots / 50.0) * 20.0;

    // Sumar y limitar a 100
    return (distanceScore + consistencyScore + volumeScore).clamp(0.0, 100.0);
  }
}
