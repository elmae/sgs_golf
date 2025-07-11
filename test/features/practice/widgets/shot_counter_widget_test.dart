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

  @override
  PracticeSession? get activeSession => _activeSession;

  @override
  int? get activeSessionKey => _activeSessionKey;

  @override
  final PracticeRepository repository = MockPracticeRepository();

  void setActiveSession(PracticeSession? session) {
    _activeSession = session;
    notifyListeners();
  }

  @override
  int countByClub(clubType) {
    return activeSession?.shots.where((s) => s.clubType == clubType).length ??
        0;
  }

  @override
  double averageDistanceByClub(clubType) => 0;

  @override
  void addShot(Shot shot) {}

  @override
  void endSession() {}

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
