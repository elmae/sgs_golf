import 'package:hive/hive.dart';
import 'package:sgs_golf/data/models/shot.dart';
part 'practice_session.g.dart';

/// Adaptador Hive para Duration
class DurationAdapter extends TypeAdapter<Duration> {
  @override
  final int typeId = 99;

  @override
  Duration read(BinaryReader reader) {
    final microseconds = reader.readInt();
    return Duration(microseconds: microseconds);
  }

  @override
  void write(BinaryWriter writer, Duration obj) {
    writer.writeInt(obj.inMicroseconds);
  }
}

/// Modelo que representa una sesión completa de práctica de golf.
@HiveType(typeId: 3)
class PracticeSession extends HiveObject {
  /// Fecha de la sesión
  @HiveField(0)
  DateTime date;

  /// Duración de la sesión
  @HiveField(1)
  Duration duration;

  /// Lista de tiros realizados en la sesión
  @HiveField(2)
  List<Shot> shots;

  /// Resumen de la sesión (puede ser un string o un objeto simple)
  @HiveField(3)
  String summary;

  PracticeSession({
    required this.date,
    required this.duration,
    required this.shots,
    required this.summary,
  });

  /// Calcula el número total de tiros
  int get totalShots => shots.length;

  /// Calcula la distancia total de la sesión
  double get totalDistance => shots.fold(0, (sum, s) => sum + s.distance);
}
