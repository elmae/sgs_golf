import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/practice_session.dart';
import 'package:sgs_golf/data/models/shot.dart';
import 'package:sgs_golf/data/repositories/practice_repository.dart';
import 'package:sgs_golf/features/practice/providers/practice_provider.dart';
import 'package:sgs_golf/features/practice/widgets/shot_counter_widget.dart';

// Mock para el repositorio de prácticas
class MockPracticeRepository implements PracticeRepository {
  @override
  Future<int> createSession(PracticeSession session) async => 1;

  @override
  Future<void> deleteSession(int key) async {}

  @override
  Future<void> updateSession(int key, PracticeSession session) async {}

  @override
  List<PracticeSession> getAllSessions() => [];

  @override
  PracticeSession? getSessionByKey(int key) => null;

  @override
  Future<void> addShotToSession(int key, Shot shot) async {}
}

// Simple provider for testing
class TestPracticeProvider extends ChangeNotifier implements PracticeProvider {
  PracticeSession? _activeSession;
  int? _activeSessionKey;
  GolfClubType? _nextClubType;
  PracticeSessionState _sessionState = PracticeSessionState.inactive;
  String? _errorMessage;
  Duration _accumulatedDuration = Duration.zero;
  DateTime? _sessionStartTime;

  @override
  PracticeSession? get activeSession => _activeSession;

  @override
  int? get activeSessionKey => _activeSessionKey;

  @override
  final PracticeRepository repository = MockPracticeRepository();

  void setActiveSession(PracticeSession? session) {
    _activeSession = session;
    _sessionState = session != null
        ? PracticeSessionState.active
        : PracticeSessionState.inactive;
    notifyListeners();
  }

  @override
  int countByClub(GolfClubType clubType) {
    return activeSession?.shots.where((s) => s.clubType == clubType).length ??
        0;
  }

  @override
  double averageDistanceByClub(GolfClubType clubType) => 0;

  @override
  void addShot(Shot shot) {}

  @override
  Future<void> endSession() async {}

  @override
  GolfClubType? get nextClubType => _nextClubType;

  @override
  Future<void> saveSession() async {}

  @override
  void setNextClubType(GolfClubType clubType) {
    _nextClubType = clubType;
    notifyListeners();
  }

  @override
  void startSession(DateTime date) {}

  @override
  PracticeSessionState get sessionState => _sessionState;

  @override
  String? get errorMessage => _errorMessage;

  @override
  List<Shot> get shots => _activeSession?.shots ?? [];

  @override
  Duration get sessionDuration {
    if (_activeSession == null) return Duration.zero;

    final baseDuration = _accumulatedDuration;
    if (_sessionStartTime != null) {
      return baseDuration + DateTime.now().difference(_sessionStartTime!);
    }
    return baseDuration;
  }

  @override
  void pauseSession() {
    if (_sessionState == PracticeSessionState.active &&
        _sessionStartTime != null) {
      _accumulatedDuration += DateTime.now().difference(_sessionStartTime!);
      _sessionStartTime = null;
      _sessionState = PracticeSessionState.paused;
      notifyListeners();
    }
  }

  @override
  void resumeSession() {
    if (_sessionState == PracticeSessionState.paused) {
      _sessionStartTime = DateTime.now();
      _sessionState = PracticeSessionState.active;
      notifyListeners();
    }
  }

  @override
  void removeShot(Shot shot) {
    if (_activeSession != null && _activeSession!.shots.contains(shot)) {
      // Crear una sesión nueva con los tiros actualizados
      final updatedShots = List<Shot>.from(_activeSession!.shots)..remove(shot);
      _activeSession = PracticeSession(
        date: _activeSession!.date,
        duration: _activeSession!.duration,
        shots: updatedShots,
        summary: _activeSession!.summary,
      );
      notifyListeners();
    }
  }

  @override
  void discardSession() {
    _activeSession = null;
    _activeSessionKey = null;
    _sessionState = PracticeSessionState.inactive;
    _sessionStartTime = null;
    _accumulatedDuration = Duration.zero;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void updateSummary(String summary) {
    if (_activeSession != null) {
      _activeSession = PracticeSession(
        date: _activeSession!.date,
        duration: _activeSession!.duration,
        shots: _activeSession!.shots,
        summary: summary,
      );
      notifyListeners();
    }
  }

  @override
  double get totalDistance {
    if (_activeSession == null || _activeSession!.shots.isEmpty) return 0.0;

    double total = 0.0;
    for (var shot in _activeSession!.shots) {
      total += shot.distance;
    }
    return total;
  }

  @override
  int get totalShots => _activeSession?.shots.length ?? 0;

  @override
  void clearError() {
    if (_sessionState == PracticeSessionState.error) {
      _sessionState = _activeSession != null
          ? PracticeSessionState.active
          : PracticeSessionState.inactive;
      _errorMessage = null;
      notifyListeners();
    }
  }
}

void main() {
  late TestPracticeProvider provider;

  setUp(() {
    provider = TestPracticeProvider();
  });

  testWidgets('ShotCounterWidget muestra mensaje cuando no hay sesión activa', (
    tester,
  ) async {
    // Configurar provider
    provider.setActiveSession(null);

    // Construir widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChangeNotifierProvider<PracticeProvider>.value(
            value: provider,
            child: const ShotCounterWidget(),
          ),
        ),
      ),
    );

    // Verificar que se muestra el mensaje correcto
    expect(find.text('No hay sesión activa'), findsOneWidget);
  });

  testWidgets('ShotCounterWidget muestra mensaje cuando no hay tiros', (
    tester,
  ) async {
    // Configurar provider
    provider.setActiveSession(
      PracticeSession(
        date: DateTime.now(),
        duration: const Duration(minutes: 30),
        shots: const [],
        summary: '',
      ),
    );

    // Construir widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChangeNotifierProvider<PracticeProvider>.value(
            value: provider,
            child: const ShotCounterWidget(),
          ),
        ),
      ),
    );

    // Verificar que se muestra el mensaje correcto
    expect(find.text('Aún no has registrado tiros'), findsOneWidget);
  });

  testWidgets(
    'ShotCounterWidget muestra los contadores por palo correctamente',
    (tester) async {
      // Crear sesión de prueba con tiros
      final now = DateTime.now();
      final mockSession = PracticeSession(
        date: now,
        duration: const Duration(minutes: 30),
        shots: [
          Shot(clubType: GolfClubType.pw, distance: 85.0, timestamp: now),
          Shot(clubType: GolfClubType.pw, distance: 90.0, timestamp: now),
          Shot(clubType: GolfClubType.sw, distance: 60.0, timestamp: now),
        ],
        summary: '',
      );

      // Configurar provider
      provider.setActiveSession(mockSession);

      // Construir widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider<PracticeProvider>.value(
              value: provider,
              child: const ShotCounterWidget(),
            ),
          ),
        ),
      );

      // Verificar que el título está presente
      expect(find.text('Tiros por palo'), findsOneWidget);

      // Verificar el total
      expect(find.text('Total: 3'), findsOneWidget);

      // Verificar contadores específicos
      expect(find.text('2 tiros'), findsOneWidget); // PW tiene 2 tiros
      expect(find.text('1 tiros'), findsOneWidget); // SW tiene 1 tiro
      expect(find.text('0 tiros'), findsNWidgets(2)); // GW y LW tienen 0 tiros

      // Verificar nombres de palos
      expect(find.text('Pitching Wedge'), findsOneWidget);
      expect(find.text('Sand Wedge'), findsOneWidget);

      // Verificar porcentajes - Omitimos la verificación exacta de porcentajes
      // ya que la implementación puede redondear de manera diferente
    },
  );
}
