import 'package:hive/hive.dart';

part 'shot.g.dart';

@HiveType(typeId: 2)
class Shot extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String clubId;

  @HiveField(2)
  double distance;

  @HiveField(3)
  DateTime timestamp;

  Shot({
    required this.id,
    required this.clubId,
    required this.distance,
    required this.timestamp,
  });
}
