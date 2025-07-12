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

    test('getAllSessions returns all sessions', () {
      when(() => box.values).thenReturn([session]);
      final sessions = repo.getAllSessions();
      expect(sessions, [session]);
      verify(() => box.values).called(1);
    });

    test('updateSession updates a session', () async {
      final updatedSession = PracticeSession(
        date: DateTime.now(),
        duration: const Duration(minutes: 90),
        shots: const [],
        summary: 'Updated summary',
      );
      when(() => box.put(1, updatedSession)).thenAnswer((_) async => {});
      await repo.updateSession(1, updatedSession);
      verify(() => box.put(1, updatedSession)).called(1);
    });

    test('deleteSession deletes a session', () async {
      when(() => box.delete(1)).thenAnswer((_) async => {});
      await repo.deleteSession(1);
      verify(() => box.delete(1)).called(1);
    });

    test('getSessionByKey returns a session', () {
      when(() => box.get(1)).thenReturn(session);
      final result = repo.getSessionByKey(1);
      expect(result, session);
      verify(() => box.get(1)).called(1);
    });

    test('getSessionByKey returns null when no session found', () {
      when(() => box.get(999)).thenReturn(null);
      final result = repo.getSessionByKey(999);
      expect(result, null);
      verify(() => box.get(999)).called(1);
    });

    test('addShotToSession does nothing when session not found', () async {
      final shot = Shot(
        clubType: GolfClubType.pw,
        distance: 100,
        timestamp: DateTime.now(),
      );
      when(() => box.get(999)).thenReturn(null);
      await repo.addShotToSession(999, shot);
      verify(() => box.get(999)).called(1);
      verifyNever(() => box.put(any(), any()));
    });
  });
}
