import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/practice_session.dart';
import 'package:sgs_golf/data/models/shot.dart';
import 'package:sgs_golf/data/repositories/practice_repository.dart';
import 'package:sgs_golf/features/practice/providers/practice_provider.dart';

class MockPracticeRepository extends Mock implements PracticeRepository {}

class FakePracticeSession extends Fake implements PracticeSession {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakePracticeSession());
  });

  late PracticeProvider provider;
  late MockPracticeRepository mockRepository;
  final testDate = DateTime(2025, 7, 11);
  final testShot = Shot(
    clubType: GolfClubType.pw,
    distance: 75.0,
    timestamp: testDate,
  );

  setUp(() {
    mockRepository = MockPracticeRepository();
    provider = PracticeProvider(mockRepository);
  });

  group('PracticeProvider initialization', () {
    test('initial state has no active session', () {
      expect(provider.activeSession, isNull);
      expect(provider.activeSessionKey, isNull);
      expect(provider.sessionState, equals(PracticeSessionState.inactive));
      expect(provider.errorMessage, isNull);
      expect(provider.shots, isEmpty);
      expect(provider.totalShots, equals(0));
      expect(provider.sessionDuration, equals(Duration.zero));
    });
  });

  group('PracticeProvider club selection', () {
    test('setNextClubType updates selected club type', () {
      // Arrange & Act
      provider.setNextClubType(GolfClubType.sw);

      // Assert
      expect(provider.nextClubType, equals(GolfClubType.sw));
    });
  });

  group('PracticeProvider session management', () {
    test('startSession initializes a new session', () {
      // Act
      provider.startSession(testDate);

      // Assert
      expect(provider.activeSession, isNotNull);
      expect(provider.activeSession?.date, equals(testDate));
      expect(provider.shots, isEmpty);
      expect(provider.activeSessionKey, isNull);
      expect(provider.sessionState, equals(PracticeSessionState.active));
    });

    test('pauseSession pauses active session and accumulates duration', () {
      // Arrange
      provider.startSession(testDate);

      // Act
      provider.pauseSession();

      // Assert
      expect(provider.sessionState, equals(PracticeSessionState.paused));
    });

    test('resumeSession resumes paused session', () {
      // Arrange
      provider.startSession(testDate);
      provider.pauseSession();

      // Act
      provider.resumeSession();

      // Assert
      expect(provider.sessionState, equals(PracticeSessionState.active));
    });

    test('discardSession resets all session data', () {
      // Arrange
      provider.startSession(testDate);
      provider.addShot(testShot);

      // Act
      provider.discardSession();

      // Assert
      expect(provider.activeSession, isNull);
      expect(provider.activeSessionKey, isNull);
      expect(provider.sessionState, equals(PracticeSessionState.inactive));
      expect(provider.shots, isEmpty);
    });

    test('updateSummary updates the session summary', () {
      // Arrange
      provider.startSession(testDate);
      const summary = 'Great session';

      // Act
      provider.updateSummary(summary);

      // Assert
      expect(provider.activeSession?.summary, equals(summary));
    });
  });

  group('PracticeProvider shot management', () {
    test('addShot adds a shot to active session', () {
      // Arrange
      provider.startSession(testDate);

      // Act
      provider.addShot(testShot);

      // Assert
      expect(provider.shots.length, equals(1));
      expect(provider.shots.first, equals(testShot));
      expect(provider.totalShots, equals(1));
    });

    test('addShot does nothing if no active session', () {
      // Act
      provider.addShot(testShot);

      // Assert
      expect(provider.activeSession, isNull);
      expect(provider.shots, isEmpty);
    });

    test('removeShot removes a shot from active session', () {
      // Arrange
      provider.startSession(testDate);
      provider.addShot(testShot);

      // Act
      provider.removeShot(testShot);

      // Assert
      expect(provider.shots, isEmpty);
      expect(provider.totalShots, equals(0));
    });
  });

  group('PracticeProvider session persistence', () {
    test('saveSession creates new session when no key exists', () async {
      // Arrange
      provider.startSession(testDate);
      when(
        () => mockRepository.createSession(any()),
      ).thenAnswer((_) async => 123);

      // Act
      await provider.saveSession();

      // Assert
      verify(() => mockRepository.createSession(any())).called(1);
      expect(provider.activeSessionKey, equals(123));
      expect(provider.sessionState, equals(PracticeSessionState.active));
    });

    test('saveSession updates existing session when key exists', () async {
      // Arrange
      provider.startSession(testDate);
      provider.addShot(testShot);
      when(
        () => mockRepository.createSession(any()),
      ).thenAnswer((_) async => 123);
      when(
        () => mockRepository.updateSession(any(), any()),
      ).thenAnswer((_) async {});

      // Act
      await provider.saveSession();
      await provider.saveSession(); // Second call should update

      // Assert
      verify(() => mockRepository.createSession(any())).called(1);
      verify(() => mockRepository.updateSession(123, any())).called(1);
    });

    test('saveSession handles errors', () async {
      // Arrange
      provider.startSession(testDate);
      when(
        () => mockRepository.createSession(any()),
      ).thenThrow(Exception('DB error'));

      // Act & Assert
      await expectLater(() => provider.saveSession(), throwsException);
      expect(provider.sessionState, equals(PracticeSessionState.error));
      expect(provider.errorMessage, isNotNull);
    });

    test('endSession saves and resets active session', () async {
      // Arrange
      provider.startSession(testDate);
      provider.addShot(testShot);
      when(
        () => mockRepository.createSession(any()),
      ).thenAnswer((_) async => 123);
      when(
        () => mockRepository.updateSession(any(), any()),
      ).thenAnswer((_) async {});

      // Act
      await provider.endSession();

      // Assert
      verify(() => mockRepository.createSession(any())).called(1);
      expect(provider.activeSession, isNull);
      expect(provider.activeSessionKey, isNull);
      expect(provider.sessionState, equals(PracticeSessionState.inactive));
    });
  });

  group('PracticeProvider statistics', () {
    test('countByClub returns correct count', () {
      // Arrange
      provider.startSession(testDate);
      provider.addShot(
        Shot(clubType: GolfClubType.pw, distance: 75.0, timestamp: testDate),
      );
      provider.addShot(
        Shot(clubType: GolfClubType.pw, distance: 80.0, timestamp: testDate),
      );
      provider.addShot(
        Shot(clubType: GolfClubType.sw, distance: 50.0, timestamp: testDate),
      );

      // Assert
      expect(provider.countByClub(GolfClubType.pw), equals(2));
      expect(provider.countByClub(GolfClubType.sw), equals(1));
      expect(provider.countByClub(GolfClubType.gw), equals(0));
    });

    test('averageDistanceByClub returns correct average', () {
      // Arrange
      provider.startSession(testDate);
      provider.addShot(
        Shot(clubType: GolfClubType.pw, distance: 75.0, timestamp: testDate),
      );
      provider.addShot(
        Shot(clubType: GolfClubType.pw, distance: 85.0, timestamp: testDate),
      );

      // Assert
      expect(provider.averageDistanceByClub(GolfClubType.pw), equals(80.0));
      expect(provider.averageDistanceByClub(GolfClubType.sw), equals(0));
    });

    test('totalDistance returns sum of all shot distances', () {
      // Arrange
      provider.startSession(testDate);
      provider.addShot(
        Shot(clubType: GolfClubType.pw, distance: 75.0, timestamp: testDate),
      );
      provider.addShot(
        Shot(clubType: GolfClubType.sw, distance: 50.0, timestamp: testDate),
      );

      // Assert
      expect(provider.totalDistance, equals(125.0));
    });
  });

  group('PracticeProvider error handling', () {
    test('clearError resets error state', () async {
      // Arrange
      provider.startSession(testDate);
      when(
        () => mockRepository.createSession(any()),
      ).thenThrow(Exception('DB error'));

      // Act
      try {
        await provider.saveSession();
      } catch (_) {}
      provider.clearError();

      // Assert
      expect(provider.sessionState, equals(PracticeSessionState.active));
      expect(provider.errorMessage, isNull);
    });
  });
}
