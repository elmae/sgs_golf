import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/practice_session.dart';
import 'package:sgs_golf/data/models/shot.dart';

void main() {
  group('Hive adapters (persistencia real)', () {
    test(
      'GolfClubType, Shot y PracticeSession persisten y leen correctamente',
      () async {
        Hive.init('test_hive');
        Hive.registerAdapter(GolfClubTypeAdapter());
        Hive.registerAdapter(ShotAdapter());
        Hive.registerAdapter(PracticeSessionAdapter());
        Hive.registerAdapter(DurationAdapter());

        final box = await Hive.openBox<PracticeSession>('testPracticeSessions');
        final shots = [
          Shot(
            clubType: GolfClubType.lw,
            distance: 20,
            timestamp: DateTime(2025, 7, 8, 12),
          ),
          Shot(
            clubType: GolfClubType.pw,
            distance: 50,
            timestamp: DateTime(2025, 7, 8, 13),
          ),
        ];
        final session = PracticeSession(
          date: DateTime(2025, 7, 8),
          duration: const Duration(minutes: 10),
          shots: shots,
          summary: '2 tiros',
        );
        await box.put('s1', session);
        final loaded = box.get('s1');
        expect(loaded, isNotNull);
        expect(loaded!.shots.length, 2);
        expect(loaded.shots.first.clubType, GolfClubType.lw);
        expect(loaded.shots.last.clubType, GolfClubType.pw);
        expect(loaded.summary, '2 tiros');
        await box.deleteFromDisk();
      },
    );
  });
}
