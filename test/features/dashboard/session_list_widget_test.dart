import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/practice_session.dart';
import 'package:sgs_golf/data/models/shot.dart';
import 'package:sgs_golf/features/dashboard/session_list_widget.dart';

void main() {
  final testSessions = [
    PracticeSession(
      date: DateTime.now().subtract(const Duration(days: 1)),
      duration: const Duration(minutes: 45),
      shots: [
        Shot(
          clubType: GolfClubType.pw,
          distance: 95.0,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
      summary: 'Sesión de prueba 1',
    ),
    PracticeSession(
      date: DateTime.now().subtract(const Duration(days: 2)),
      duration: const Duration(minutes: 30),
      shots: [
        Shot(
          clubType: GolfClubType.sw,
          distance: 85.0,
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ],
      summary: 'Sesión de prueba 2',
    ),
  ];

  testWidgets('SessionListWidget muestra las sesiones correctamente', (
    tester,
  ) async {
    bool tapCalled = false;
    bool deleteCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SessionListWidget(
            sessions: testSessions,
            onSessionTap: (_) => tapCalled = true,
            onSessionDelete: (_) => deleteCalled = true,
          ),
        ),
      ),
    );

    // Verificar que las sesiones se muestran
    expect(find.text('Sesión de prueba 1'), findsOneWidget);
    expect(find.text('Sesión de prueba 2'), findsOneWidget);

    // Verificar que la duración se muestra correctamente
    expect(find.text('Duración: 45 minutos'), findsOneWidget);
    expect(find.text('Duración: 30 minutos'), findsOneWidget);

    // Probar la interacción de tap
    await tester.tap(find.text('Sesión de prueba 1'));
    expect(tapCalled, isTrue);

    // Probar la interacción de eliminar
    await tester.tap(find.byIcon(Icons.delete).first);
    expect(deleteCalled, isTrue);
  });

  testWidgets('SessionListWidget muestra mensaje cuando no hay sesiones', (
    tester,
  ) async {
    const testMessage = 'No hay sesiones disponibles';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SessionListWidget(sessions: [], emptyMessage: testMessage),
        ),
      ),
    );

    // Verificar que se muestra el mensaje de vacío
    expect(find.text(testMessage), findsOneWidget);
    expect(find.byIcon(Icons.sports_golf), findsOneWidget);
  });

  testWidgets('SessionListWidget respeta el límite máximo de sesiones', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SessionListWidget(
            sessions: testSessions,
            maxSessions: 1, // Solo mostrar 1 sesión
          ),
        ),
      ),
    );

    // Verificar que solo se muestra la primera sesión
    expect(find.text('Sesión de prueba 1'), findsOneWidget);
    expect(find.text('Sesión de prueba 2'), findsNothing);
  });
}
