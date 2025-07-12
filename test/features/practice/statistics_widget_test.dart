import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/practice_session.dart';
import 'package:sgs_golf/data/models/shot.dart';
import 'package:sgs_golf/data/repositories/practice_repository.dart';
import 'package:sgs_golf/features/practice/practice_screen.dart';
import 'package:sgs_golf/features/practice/providers/practice_provider.dart';
import 'package:sgs_golf/features/practice/statistics_widget.dart';

// Implementación sencilla del repositorio para pruebas
class FakePracticeRepository implements PracticeRepository {
  @override
  Future<void> addShotToSession(int key, Shot shot) async {}

  @override
  Future<int> createSession(PracticeSession session) async => 1;

  @override
  Future<void> deleteSession(int key) async {}

  @override
  List<PracticeSession> getAllSessions() => [];

  @override
  PracticeSession? getSessionByKey(int key) => null;

  @override
  Future<void> updateSession(int key, PracticeSession session) async {}
}

void main() {
  group('StatisticsWidget Integration Tests', () {
    late PracticeProvider provider;

    Widget createTestApp() {
      return MaterialApp(
        home: ChangeNotifierProvider<PracticeProvider>.value(
          value: provider,
          child: const PracticeScreen(),
        ),
      );
    }

    setUp(() {
      provider = PracticeProvider(FakePracticeRepository());
      provider.startSession(DateTime.now());
    });

    testWidgets('StatisticsWidget shows correct data after adding shots', (
      tester,
    ) async {
      // Construir la app
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Verificar que inicialmente el contador de tiros es cero
      expect(find.text('Total: 0 tiros'), findsOneWidget);

      // Añadir un tiro al provider
      provider.addShot(
        Shot(
          clubType: GolfClubType.pw,
          distance: 100.0,
          timestamp: DateTime.now(),
        ),
      );

      // Re-renderizar
      await tester.pump();

      // Verificar que el contador de tiros se actualizó
      expect(find.text('Total: 1 tiros'), findsOneWidget);

      // Verificar que el widget de estadísticas existe
      expect(find.byType(StatisticsWidget), findsOneWidget);

      // Verificar que se muestra la distancia correcta
      expect(find.text('100.0 m'), findsAtLeastNWidgets(1));
    });

    testWidgets('StatisticsWidget updates when shots are added', (
      tester,
    ) async {
      // Construir la app
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Añadir un tiro
      provider.addShot(
        Shot(
          clubType: GolfClubType.pw,
          distance: 90.0,
          timestamp: DateTime.now(),
        ),
      );
      await tester.pump();

      // Añadir un segundo tiro
      provider.addShot(
        Shot(
          clubType: GolfClubType.sw,
          distance: 70.0,
          timestamp: DateTime.now(),
        ),
      );
      await tester.pump();

      // Verificar contadores
      expect(find.text('Total: 2 tiros'), findsOneWidget);

      // Verificar promedio (90 + 70)/2 = 80.0
      expect(find.text('80.0 m'), findsAtLeastNWidgets(1));
    });
  });
}
