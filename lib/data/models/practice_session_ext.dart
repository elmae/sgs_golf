import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/practice_session.dart';
import 'package:sgs_golf/data/models/shot.dart';

extension PracticeSessionCopyWith on PracticeSession {
  PracticeSession copyWith({
    DateTime? date,
    Duration? duration,
    List<Shot>? shots,
    String? summary,
  }) {
    return PracticeSession(
      date: date ?? this.date,
      duration: duration ?? this.duration,
      shots: shots ?? this.shots,
      summary: summary ?? this.summary,
    );
  }

  /// Obtiene los tiros filtrados por tipo de palo
  List<Shot> shotsByClub(GolfClubType clubType) {
    return shots.where((s) => s.clubType == clubType).toList();
  }

  /// Calcula el promedio de distancia por palo
  double averageDistanceByClub(GolfClubType clubType) {
    final clubShots = shotsByClub(clubType);
    if (clubShots.isEmpty) return 0;
    return clubShots.map((s) => s.distance).reduce((a, b) => a + b) /
        clubShots.length;
  }

  /// Cuenta los tiros por palo
  int countByClub(GolfClubType clubType) {
    return shotsByClub(clubType).length;
  }
}
