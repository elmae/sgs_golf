import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/practice_session.dart';
import 'package:sgs_golf/data/models/shot.dart';
import 'package:sgs_golf/data/repositories/practice_repository.dart';
import 'package:sgs_golf/features/dashboard/providers/dashboard_provider.dart';
import 'package:sgs_golf/features/dashboard/session_list_widget.dart';

class MockPracticeRepository extends Mock implements PracticeRepository {}

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
    expect(find.text('45 min'), findsOneWidget);
    expect(find.text('30 min'), findsOneWidget);

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

  group('SessionListWidget con filtros y ordenamiento', () {
    late MockPracticeRepository mockRepository;
    late DashboardProvider provider;

    setUp(() {
      mockRepository = MockPracticeRepository();
      when(() => mockRepository.getAllSessions()).thenReturn(testSessions);
      provider = DashboardProvider(mockRepository);
    });

    testWidgets('Muestra controles de filtro cuando showFilters es true', (
      tester,
    ) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<DashboardProvider>.value(
          value: provider,
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Expanded(
                    child: SessionListWidget(
                      sessions: testSessions,
                      showFilters: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verificar que se muestran los botones de filtro y ordenamiento
      expect(find.text('Ordenar'), findsOneWidget);
      expect(find.text('Filtrar'), findsOneWidget);
    });

    testWidgets('Muestra opciones de ordenamiento al hacer tap en Ordenar', (
      tester,
    ) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<DashboardProvider>.value(
          value: provider,
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Expanded(
                    child: SessionListWidget(
                      sessions: testSessions,
                      showFilters: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Tap en el botón de ordenar
      await tester.tap(find.text('Ordenar'));
      await tester.pumpAndSettle();

      // Verificar que se muestran las opciones de ordenamiento
      expect(find.text('Más reciente primero'), findsOneWidget);
      expect(find.text('Más antigua primero'), findsOneWidget);
      expect(find.text('Mayor duración primero'), findsOneWidget);
      expect(find.text('Menor duración primero'), findsOneWidget);
      expect(find.text('Mayor cantidad de tiros'), findsOneWidget);
      expect(find.text('Menor cantidad de tiros'), findsOneWidget);
    });

    testWidgets('Muestra panel de filtros al hacer tap en Filtrar', (
      tester,
    ) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<DashboardProvider>.value(
          value: provider,
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Expanded(
                    child: SessionListWidget(
                      sessions: testSessions,
                      showFilters: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Tap en el botón de filtrar
      await tester.tap(find.text('Filtrar'));
      await tester.pumpAndSettle();

      // Verificar que se muestra el panel de filtros
      expect(find.text('Filtrar por:'), findsOneWidget);
      expect(find.text('Rango de fechas:'), findsOneWidget);
      expect(find.text('Tipo de palo:'), findsOneWidget);
      expect(find.text('Limpiar filtros'), findsOneWidget);
    });

    testWidgets(
      'Muestra mensaje cuando no hay sesiones con los filtros actuales',
      (tester) async {
        // Configurar el provider para devolver una lista vacía después de filtrar
        provider.setClubTypeFilter(GolfClubType.lw); // No hay sesiones con LW

        await tester.pumpWidget(
          ChangeNotifierProvider<DashboardProvider>.value(
            value: provider,
            child: MaterialApp(
              home: Scaffold(
                body: Column(
                  children: [
                    Expanded(
                      child: SessionListWidget(
                        sessions: provider.sessions,
                        showFilters: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        // Verificar que se muestra el mensaje de filtros sin resultados
        expect(
          find.text('No se encontraron sesiones con los filtros actuales'),
          findsOneWidget,
        );
        expect(find.byIcon(Icons.filter_list_off), findsOneWidget);
      },
    );
  });
}
