import 'package:hive/hive.dart';

part 'golf_club.g.dart';

@HiveType(typeId: 1)
class GolfClub extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String type;

  GolfClub({required this.id, required this.name, required this.type});
}
