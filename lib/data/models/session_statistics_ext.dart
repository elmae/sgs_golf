import 'dart:math';

import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/session_statistics.dart';

/// Extensión que añade métodos de análisis estadístico avanzado
/// y comparativa entre sesiones.
extension SessionStatisticsAnalysis on SessionStatistics {
  /// Calcula la mejora porcentual en distancia promedio comparado con otra sesión
  /// Retorna un valor positivo si esta sesión tiene mayor distancia promedio
  double distanceImprovement(SessionStatistics other) {
    if (other.averageDistance <= 0) return 0.0;
    if (averageDistance <= 0) return -100.0;

    return ((averageDistance - other.averageDistance) / other.averageDistance) *
        100;
  }

  /// Calcula la mejora porcentual en distancia promedio para un tipo de palo específico
  double distanceImprovementForClub(
    SessionStatistics other,
    GolfClubType club,
  ) {
    final thisAvg = averageDistanceByClub[club] ?? 0.0;
    final otherAvg = other.averageDistanceByClub[club] ?? 0.0;

    if (otherAvg <= 0) return 0.0;
    if (thisAvg <= 0) return -100.0;

    return ((thisAvg - otherAvg) / otherAvg) * 100;
  }

  /// Calcula si hay mejora en la tasa de tiros por minuto
  double? shotsPerMinuteImprovement(SessionStatistics other) {
    if (shotsPerMinute == null || other.shotsPerMinute == null) return null;
    if (other.shotsPerMinute! <= 0) return 0.0;

    return ((shotsPerMinute! - other.shotsPerMinute!) / other.shotsPerMinute!) *
        100;
  }

  /// Determina si esta sesión fue generalmente mejor que otra
  bool isBetterThan(
    SessionStatistics other, {
    double distanceWeight = 0.7,
    double countWeight = 0.3,
  }) {
    // Si no hay datos suficientes, no se puede determinar
    if (totalShots == 0 || other.totalShots == 0) return false;

    // Calcula la mejora ponderada basada en distancia y conteo
    final distanceImprove = distanceImprovement(other);
    final countImprove = totalShots > other.totalShots
        ? ((totalShots - other.totalShots) / other.totalShots) * 100
        : -((other.totalShots - totalShots) / totalShots) * 100;

    final weightedImprovement =
        (distanceImprove * distanceWeight) + (countImprove * countWeight);

    return weightedImprovement > 0;
  }

  /// Proporciona un resumen textual de las mejoras respecto a otra sesión
  String improvementSummary(SessionStatistics other) {
    if (totalShots == 0 || other.totalShots == 0) {
      return 'No hay datos suficientes para comparar';
    }

    final distImprove = distanceImprovement(other);
    final distSign = distImprove >= 0 ? '+' : '';

    final shotImprove = totalShots - other.totalShots;
    final shotSign = shotImprove >= 0 ? '+' : '';

    return 'Distancia: $distSign${distImprove.toStringAsFixed(1)}%, '
        'Tiros: $shotSign$shotImprove';
  }

  /// Calcula métricas de consistencia (desviación estándar) a partir
  /// de los promedios y distancias
  ///
  /// Nota: Este es un cálculo simulado ya que no tenemos acceso a los tiros individuales
  /// en este objeto de estadísticas, solo a los promedios
  Map<GolfClubType, double> get consistencyByClub {
    // La consistencia se calcula como un porcentaje:
    // 100% - (desviación estándar estimada / promedio) * 100
    // Cuanto mayor sea el valor, más consistente es el jugador

    return {
      for (final club in GolfClubType.values) club: _calculateConsistency(club),
    };
  }

  /// Calcula un índice de consistencia (0-100) para un tipo de palo
  double _calculateConsistency(GolfClubType club) {
    final count = shotCounts[club] ?? 0;
    final avg = averageDistanceByClub[club] ?? 0.0;

    // Si no hay tiros, la consistencia es 0
    if (count < 3 || avg <= 0) return 0.0;

    // Estimamos la desviación estándar como un porcentaje del promedio
    // basado en el número de tiros (más tiros tienden a tener más variabilidad)
    // Este es un modelo aproximado ya que no tenemos los valores individuales
    final estimatedStdDev = sqrt(count) * (avg * 0.05);

    // Calculamos la consistencia como porcentaje (100% es perfecta)
    final consistency = max(0.0, 100.0 - (estimatedStdDev / avg) * 100);

    return min(consistency, 100.0); // Limitamos a 100%
  }

  /// Calcula la consistencia general combinando todas las métricas
  double get overallConsistency {
    if (totalShots == 0) return 0.0;

    // Ponderamos la consistencia por el número de tiros por palo
    double weightedSum = 0.0;
    int totalWeights = 0;

    for (final club in GolfClubType.values) {
      final count = shotCounts[club] ?? 0;
      if (count > 0) {
        weightedSum += _calculateConsistency(club) * count;
        totalWeights += count;
      }
    }

    return totalWeights > 0 ? weightedSum / totalWeights : 0.0;
  }
}
