import 'package:hive/hive.dart';
import 'package:sgs_golf/data/models/golf_club.dart';

part 'shot.g.dart';

/// Modelo que representa un tiro individual en una sesión de práctica.
@HiveType(typeId: 2)
class Shot extends HiveObject {
  /// Tipo de palo utilizado para el tiro
  @HiveField(0)
  GolfClubType clubType;

  /// Distancia alcanzada en metros
  @HiveField(1)
  double distance;

  /// Marca de tiempo del tiro
  @HiveField(2)
  DateTime timestamp;

  Shot({
    required this.clubType,
    required this.distance,
    required this.timestamp,
  });

  @override
  String toString() =>
      'Shot(clubType: $clubType, distance: $distance, timestamp: $timestamp)';
}
