import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/practice_session.dart';
import 'package:sgs_golf/data/models/shot.dart';
import 'package:sgs_golf/data/repositories/practice_repository.dart';

class MockPracticeSessionBox extends Mock implements Box<PracticeSession> {}

class FakePracticeSession extends Fake implements PracticeSession {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakePracticeSession());
  });

  group('PracticeRepository', () {
    late MockPracticeSessionBox box;
    late PracticeRepository repo;
    late PracticeSession session;

    setUp(() {
      box = MockPracticeSessionBox();
      repo = PracticeRepository(box);
      session = PracticeSession(
        date: DateTime.now(),
        duration: const Duration(minutes: 60),
        shots: const [],
        summary: '',
      );
    });

    test('createSession adds a session', () async {
      when(() => box.add(session)).thenAnswer((_) async => 1);
      final key = await repo.createSession(session);
      expect(key, 1);
      verify(() => box.add(session)).called(1);
    });

    test('addShotToSession adds a shot', () async {
      final shot = Shot(
        clubType: GolfClubType.pw,
        distance: 100,
        timestamp: DateTime.now(),
      );
      when(() => box.get(1)).thenReturn(session);
      when(() => box.put(1, any())).thenAnswer((_) async => {});
      await repo.addShotToSession(1, shot);
      verify(() => box.put(1, any())).called(1);
    });
  });
}
