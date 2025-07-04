import 'package:hive/hive.dart';

part 'practice_session.g.dart';

@HiveType(typeId: 3)
class PracticeSession extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  List<String> shotIds;

  PracticeSession({
    required this.id,
    required this.userId,
    required this.date,
    required this.shotIds,
  });
}
