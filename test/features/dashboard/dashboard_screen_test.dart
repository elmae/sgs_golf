import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/practice_session.dart';
import 'package:sgs_golf/data/models/shot.dart';
import 'package:sgs_golf/data/repositories/practice_repository.dart';
import 'package:sgs_golf/features/dashboard/dashboard_screen.dart';
import 'package:sgs_golf/features/dashboard/providers/dashboard_provider.dart';

class MockPracticeRepository extends Mock implements PracticeRepository {}

void main() {
  late MockPracticeRepository mockPracticeRepository;
  late List<PracticeSession> mockSessions;

  setUp(() {
    mockPracticeRepository = MockPracticeRepository();

    // Crear datos de prueba
    mockSessions = [
      PracticeSession(
        date: DateTime.now().subtract(const Duration(days: 1)),
        duration: const Duration(minutes: 45),
        shots: [
          Shot(
            clubType: GolfClubType.pw,
            distance: 95.0,
            timestamp: DateTime.now().subtract(
              const Duration(days: 1, hours: 1),
            ),
          ),
          Shot(
            clubType: GolfClubType.pw,
            distance: 98.5,
            timestamp: DateTime.now().subtract(
              const Duration(days: 1, minutes: 50),
            ),
          ),
        ],
        summary: 'Buena sesión con PW',
      ),
      PracticeSession(
        date: DateTime.now().subtract(const Duration(days: 3)),
        duration: const Duration(minutes: 60),
        shots: [
          Shot(
            clubType: GolfClubType.sw,
            distance: 78.0,
            timestamp: DateTime.now().subtract(
              const Duration(days: 3, hours: 1),
            ),
          ),
          Shot(
            clubType: GolfClubType.lw,
            distance: 65.5,
            timestamp: DateTime.now().subtract(
              const Duration(days: 3, minutes: 45),
            ),
          ),
        ],
        summary: 'Práctica de SW y LW',
      ),
    ];
  });

  testWidgets('DashboardScreen muestra correctamente las sesiones', (
    tester,
  ) async {
    // Configurar el mock
    when(
      () => mockPracticeRepository.getAllSessions(),
    ).thenReturn(mockSessions);

    // Crear el widget bajo test con el provider
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => DashboardProvider(mockPracticeRepository),
          child: const DashboardScreen(),
        ),
      ),
    );

    // Primera renderización puede mostrar indicador de carga
    await tester.pumpAndSettle();

    // Verificar que se muestra el título
    expect(find.text('SGS Golf'), findsOneWidget);

    // Verificar que se muestran las estadísticas
    expect(find.text('Estadísticas'), findsOneWidget);
    expect(find.text('Sesiones'), findsOneWidget);

    // Verificar que se muestran los botones de acceso rápido
    expect(find.text('Práctica'), findsOneWidget);
    expect(find.text('Análisis'), findsOneWidget);
    expect(find.text('Exportar'), findsOneWidget);

    // Verificar que se muestran las sesiones recientes
    expect(find.text('Sesiones recientes'), findsOneWidget);
    expect(find.text('Buena sesión con PW'), findsOneWidget);
    expect(find.text('Práctica de SW y LW'), findsOneWidget);
  });

  testWidgets('DashboardScreen muestra estado vacío cuando no hay sesiones', (
    tester,
  ) async {
    // Configurar el mock para devolver lista vacía
    when(() => mockPracticeRepository.getAllSessions()).thenReturn([]);

    // Crear el widget bajo test con el provider
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => DashboardProvider(mockPracticeRepository),
          child: const DashboardScreen(),
        ),
      ),
    );

    // Esperar a que se complete la carga
    await tester.pumpAndSettle();

    // Verificar mensaje de bienvenida
    expect(find.text('¡Bienvenido a SGS Golf!'), findsOneWidget);
    expect(
      find.text('Comienza registrando tu primera sesión de práctica'),
      findsOneWidget,
    );
    expect(find.text('Iniciar práctica'), findsOneWidget);
  });

  testWidgets('DashboardScreen muestra error cuando falla la carga', (
    tester,
  ) async {
    // Configurar el mock para lanzar una excepción
    when(
      () => mockPracticeRepository.getAllSessions(),
    ).thenThrow(Exception('Error de conexión'));

    // Crear el widget bajo test con el provider
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => DashboardProvider(mockPracticeRepository),
          child: const DashboardScreen(),
        ),
      ),
    );

    // Esperar a que se complete la carga
    await tester.pumpAndSettle();

    // Verificar que se muestra el mensaje de error
    expect(
      find.text('Error al cargar sesiones: Exception: Error de conexión'),
      findsOneWidget,
    );
    expect(find.text('Reintentar'), findsOneWidget);
  });

  testWidgets('DashboardScreen refresca datos al presionar botón', (
    tester,
  ) async {
    // Configurar el mock
    when(
      () => mockPracticeRepository.getAllSessions(),
    ).thenReturn(mockSessions);

    // Crear el widget bajo test con el provider
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => DashboardProvider(mockPracticeRepository),
          child: const DashboardScreen(),
        ),
      ),
    );

    // Esperar a que se complete la carga
    await tester.pumpAndSettle();

    // Verificar que se llama al método loadSessions al inicio
    // El constructor llama a loadSessions una vez, y luego el initState del widget llama otra vez
    verify(() => mockPracticeRepository.getAllSessions()).called(2);

    // Limpiar el recuento de llamadas para el siguiente paso
    clearInteractions(mockPracticeRepository);

    // Presionar el botón de refrescar
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pumpAndSettle();

    // Verificar que se vuelve a llamar al método getAllSessions
    verify(() => mockPracticeRepository.getAllSessions()).called(1);
  });

  testWidgets('Navegación al hacer tap en botón de Práctica en dashboard', (
    tester,
  ) async {
    // Configurar el mock
    when(
      () => mockPracticeRepository.getAllSessions(),
    ).thenReturn(mockSessions);

    // Preparar mapa de rutas para pruebas de navegación
    final mockRoutes = {
      '/practice': (context) => const Scaffold(
        key: Key('practice-screen'),
        body: Center(child: Text('Pantalla de Práctica')),
      ),
    };

    // Crear el widget bajo test con el provider
    await tester.pumpWidget(
      MaterialApp(
        routes: mockRoutes,
        home: ChangeNotifierProvider(
          create: (_) => DashboardProvider(mockPracticeRepository),
          child: const DashboardScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Buscar y pulsar el botón de Práctica
    expect(find.text('Práctica'), findsOneWidget);
    await tester.tap(find.text('Práctica'));
    await tester.pumpAndSettle();

    // Verificar que se ha navegado a la pantalla correcta
    expect(find.byKey(const Key('practice-screen')), findsOneWidget);
    expect(find.text('Pantalla de Práctica'), findsOneWidget);
  });

  testWidgets('Navegación al hacer tap en botón de Análisis en dashboard', (
    tester,
  ) async {
    // Configurar el mock
    when(
      () => mockPracticeRepository.getAllSessions(),
    ).thenReturn(mockSessions);

    // Preparar mapa de rutas para pruebas de navegación
    final mockRoutes = {
      '/analysis': (context) => const Scaffold(
        key: Key('analysis-screen'),
        body: Center(child: Text('Pantalla de Análisis')),
      ),
    };

    // Crear el widget bajo test con el provider
    await tester.pumpWidget(
      MaterialApp(
        routes: mockRoutes,
        home: ChangeNotifierProvider(
          create: (_) => DashboardProvider(mockPracticeRepository),
          child: const DashboardScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Buscar y pulsar el botón de Análisis
    expect(find.text('Análisis'), findsOneWidget);
    await tester.tap(find.text('Análisis'));
    await tester.pumpAndSettle();

    // Verificar que se ha navegado a la pantalla correcta
    expect(find.byKey(const Key('analysis-screen')), findsOneWidget);
    expect(find.text('Pantalla de Análisis'), findsOneWidget);
  });

  testWidgets('Navegación al hacer tap en botón de Exportar en dashboard', (
    tester,
  ) async {
    // Configurar el mock
    when(
      () => mockPracticeRepository.getAllSessions(),
    ).thenReturn(mockSessions);

    // Preparar mapa de rutas para pruebas de navegación
    final mockRoutes = {
      '/export': (context) => const Scaffold(
        key: Key('export-screen'),
        body: Center(child: Text('Pantalla de Exportación')),
      ),
    };

    // Crear el widget bajo test con el provider
    await tester.pumpWidget(
      MaterialApp(
        routes: mockRoutes,
        home: ChangeNotifierProvider(
          create: (_) => DashboardProvider(mockPracticeRepository),
          child: const DashboardScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Buscar y pulsar el botón de Exportar
    expect(find.text('Exportar'), findsOneWidget);
    await tester.tap(find.text('Exportar'));
    await tester.pumpAndSettle();

    // Verificar que se ha navegado a la pantalla correcta
    expect(find.byKey(const Key('export-screen')), findsOneWidget);
    expect(find.text('Pantalla de Exportación'), findsOneWidget);
  });
}
