import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/practice_session.dart';
import 'package:sgs_golf/data/models/shot.dart';
import 'package:sgs_golf/data/repositories/practice_repository.dart';
import 'package:sgs_golf/features/dashboard/providers/dashboard_provider.dart';

class MockPracticeRepository extends Mock implements PracticeRepository {}

void main() {
  late MockPracticeRepository mockRepository;
  late DashboardProvider dashboardProvider;
  late List<PracticeSession> mockSessions;

  setUp(() {
    mockRepository = MockPracticeRepository();
    dashboardProvider = DashboardProvider(mockRepository);

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

  test('loadSessions carga y ordena las sesiones correctamente', () async {
    // Configurar mock
    when(() => mockRepository.getAllSessions()).thenReturn(mockSessions);

    // Ejecutar método a probar
    await dashboardProvider.loadSessions();

    // Verificar resultados
    expect(dashboardProvider.sessions.length, 2);
    expect(dashboardProvider.isLoading, false);
    expect(dashboardProvider.error, null);

    // Verificar ordenamiento (más reciente primero)
    expect(dashboardProvider.sessions.first.date, mockSessions[0].date);
    expect(dashboardProvider.sessions.last.date, mockSessions[1].date);

    // Verificar que se llamó al método del repositorio
    // El constructor también llama a loadSessions, por lo que se llama 2 veces en total
    verify(() => mockRepository.getAllSessions()).called(2);
  });

  test('loadSessions maneja errores correctamente', () async {
    // Configurar mock para simular un error
    when(
      () => mockRepository.getAllSessions(),
    ).thenThrow(Exception('Error de prueba'));

    // Ejecutar método a probar
    await dashboardProvider.loadSessions();

    // Verificar resultados
    expect(dashboardProvider.sessions, isEmpty);
    expect(dashboardProvider.isLoading, false);
    expect(dashboardProvider.error, contains('Error al cargar sesiones'));

    // Verificar que se llamó al método del repositorio
    // El constructor también llama a loadSessions, por lo que se llama 2 veces en total
    verify(() => mockRepository.getAllSessions()).called(2);
  });

  test('refreshData recarga las sesiones', () async {
    // Configurar mock
    when(() => mockRepository.getAllSessions()).thenReturn(mockSessions);

    // Ejecutar método a probar
    await dashboardProvider.refreshData();

    // Verificar resultados
    expect(dashboardProvider.sessions.length, 2);
    expect(dashboardProvider.isLoading, false);

    // Verificar que se llamó al método del repositorio
    // El constructor también llama a loadSessions, por lo que se llama 2 veces en total
    verify(() => mockRepository.getAllSessions()).called(2);
  });

  test('deleteSession elimina una sesión y recarga la lista', () async {
    // Configurar mocks
    when(() => mockRepository.deleteSession(any())).thenAnswer((_) async {});
    when(() => mockRepository.getAllSessions()).thenReturn(mockSessions);

    // Ejecutar método a probar
    await dashboardProvider.deleteSession(1);

    // Verificar resultados
    expect(dashboardProvider.isLoading, false);

    // Verificar que se llamaron a los métodos del repositorio
    verify(() => mockRepository.deleteSession(1)).called(1);
    // El constructor también llama a loadSessions, y luego deleteSession llama de nuevo
    verify(() => mockRepository.getAllSessions()).called(2);
  });

  test('deleteSession maneja errores correctamente', () async {
    // Configurar mock para simular un error
    when(
      () => mockRepository.deleteSession(any()),
    ).thenThrow(Exception('Error al eliminar'));

    // Permitir llamada inicial desde constructor
    when(() => mockRepository.getAllSessions()).thenReturn([]);

    // Crear nuevo provider para este test específico para controlar llamadas
    final testProvider = DashboardProvider(mockRepository);

    // Limpiar contador de llamadas después de la inicialización
    clearInteractions(mockRepository);

    // Ejecutar método a probar
    await testProvider.deleteSession(1);

    // Verificar resultados
    expect(testProvider.isLoading, false);
    expect(testProvider.error, contains('Error al eliminar sesión'));

    // Verificar que se llamó al método del repositorio
    verify(() => mockRepository.deleteSession(1)).called(1);
    // Cuando hay error, no debería cargar las sesiones de nuevo
    verifyNever(() => mockRepository.getAllSessions());
  });

  test('métodos de estadísticas calculan valores correctamente', () {
    // Configurar mock
    when(() => mockRepository.getAllSessions()).thenReturn(mockSessions);
    dashboardProvider.loadSessions();

    // Probar métodos de estadísticas
    expect(dashboardProvider.totalSessions, 2);
    expect(dashboardProvider.totalShots, 4); // 2 tiros en cada sesión
    expect(
      dashboardProvider.averageShotsPerSession,
      2.0,
    ); // 4 tiros / 2 sesiones
  });

  test('estadísticas son 0 cuando no hay sesiones', () {
    // Configurar mock para devolver lista vacía
    when(() => mockRepository.getAllSessions()).thenReturn([]);
    dashboardProvider.loadSessions();

    // Probar métodos de estadísticas
    expect(dashboardProvider.totalSessions, 0);
    expect(dashboardProvider.totalShots, 0);
    expect(dashboardProvider.averageShotsPerSession, 0);
  });
}
