import 'package:hive/hive.dart';

part 'golf_club.g.dart';

/// Enum que representa los tipos de palos de golf utilizados en práctica.
///
/// - [pw]: Pitching Wedge
/// - [gw]: Gap Wedge
/// - [sw]: Sand Wedge
/// - [lw]: Lob Wedge
@HiveType(typeId: 10)
enum GolfClubType {
  /// Pitching Wedge
  @HiveField(0)
  pw,

  /// Gap Wedge
  @HiveField(1)
  gw,

  /// Sand Wedge
  @HiveField(2)
  sw,

  /// Lob Wedge
  @HiveField(3)
  lw,
}

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
