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

  // Fechas fijas para pruebas
  final DateTime now = DateTime.now();
  final DateTime yesterday = now.subtract(const Duration(days: 1));
  final DateTime threeDaysAgo = now.subtract(const Duration(days: 3));

  setUp(() {
    mockRepository = MockPracticeRepository();
    dashboardProvider = DashboardProvider(mockRepository);

    // Crear datos de prueba
    mockSessions = [
      PracticeSession(
        date: yesterday,
        duration: const Duration(minutes: 45),
        shots: [
          Shot(
            clubType: GolfClubType.pw,
            distance: 95.0,
            timestamp: yesterday.subtract(const Duration(hours: 1)),
          ),
          Shot(
            clubType: GolfClubType.pw,
            distance: 98.5,
            timestamp: yesterday.subtract(const Duration(minutes: 50)),
          ),
        ],
        summary: 'Buena sesión con PW',
      ),
      PracticeSession(
        date: threeDaysAgo,
        duration: const Duration(minutes: 60),
        shots: [
          Shot(
            clubType: GolfClubType.sw,
            distance: 78.0,
            timestamp: threeDaysAgo.subtract(const Duration(hours: 1)),
          ),
          Shot(
            clubType: GolfClubType.lw,
            distance: 65.5,
            timestamp: threeDaysAgo.subtract(const Duration(minutes: 45)),
          ),
        ],
        summary: 'Práctica de SW y LW',
      ),
    ];
  });

  group('Métodos básicos', () {
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
  });

  group('Estadísticas', () {
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
  });

  group('Ordenamiento', () {
    setUp(() {
      // Configurar mock para todos los tests de este grupo
      when(() => mockRepository.getAllSessions()).thenReturn(mockSessions);
      dashboardProvider.loadSessions();
      // Limpiar interacciones después de la carga inicial
      clearInteractions(mockRepository);
    });

    test('setSortOption por fecha descendente ordena correctamente', () {
      // Ejecutar método a probar
      dashboardProvider.setSortOption(SessionSortOption.dateDesc);

      // Verificar ordenamiento
      expect(dashboardProvider.sessions.first.date, yesterday);
      expect(dashboardProvider.sessions.last.date, threeDaysAgo);
    });

    test('setSortOption por fecha ascendente ordena correctamente', () {
      // Ejecutar método a probar
      dashboardProvider.setSortOption(SessionSortOption.dateAsc);

      // Verificar ordenamiento
      expect(dashboardProvider.sessions.first.date, threeDaysAgo);
      expect(dashboardProvider.sessions.last.date, yesterday);
    });

    test('setSortOption por duración descendente ordena correctamente', () {
      // Ejecutar método a probar
      dashboardProvider.setSortOption(SessionSortOption.durationDesc);

      // Verificar ordenamiento (60 minutos primero, 45 minutos después)
      expect(dashboardProvider.sessions.first.duration.inMinutes, 60);
      expect(dashboardProvider.sessions.last.duration.inMinutes, 45);
    });

    test('setSortOption por duración ascendente ordena correctamente', () {
      // Ejecutar método a probar
      dashboardProvider.setSortOption(SessionSortOption.durationAsc);

      // Verificar ordenamiento (45 minutos primero, 60 minutos después)
      expect(dashboardProvider.sessions.first.duration.inMinutes, 45);
      expect(dashboardProvider.sessions.last.duration.inMinutes, 60);
    });
  });

  group('Filtrado', () {
    setUp(() {
      // Configurar mock para todos los tests de este grupo
      when(() => mockRepository.getAllSessions()).thenReturn(mockSessions);
      dashboardProvider.loadSessions();
      // Limpiar interacciones después de la carga inicial
      clearInteractions(mockRepository);
    });

    test('setDateRange filtra correctamente por fechas', () {
      // Establecer rango que solo incluya la sesión de ayer
      final twoDaysAgo = now.subtract(const Duration(days: 2));
      dashboardProvider.setDateRange(twoDaysAgo, now);

      // Verificar filtrado
      expect(dashboardProvider.sessions.length, 1);
      expect(dashboardProvider.sessions.first.date, yesterday);
    });

    test('setClubTypeFilter filtra correctamente por tipo de palo', () {
      // Filtrar solo sesiones con palos SW
      dashboardProvider.setClubTypeFilter(GolfClubType.sw);

      // Verificar filtrado - solo la segunda sesión tiene un tiro con SW
      expect(dashboardProvider.sessions.length, 1);
      expect(dashboardProvider.sessions.first.date, threeDaysAgo);

      // Cambiar filtro a PW
      dashboardProvider.setClubTypeFilter(GolfClubType.pw);

      // Verificar filtrado - solo la primera sesión tiene tiros con PW
      expect(dashboardProvider.sessions.length, 1);
      expect(dashboardProvider.sessions.first.date, yesterday);
    });

    test('clearFilters resetea todos los filtros', () {
      // Verificar que al inicio tenemos todas las sesiones
      expect(dashboardProvider.sessions.length, 2);

      // Aplicamos un filtro de fecha que solo incluye una sesión
      final twoDaysAgo = now.subtract(const Duration(days: 2));
      dashboardProvider.setDateRange(twoDaysAgo, now);

      // Verificar que se aplicaron los filtros (solo la sesión de ayer pasa)
      expect(dashboardProvider.sessions.length, 1);

      // Limpiar filtros
      dashboardProvider.clearFilters();

      // Verificar que se han restablecido todos los filtros
      expect(dashboardProvider.sessions.length, 2);
      expect(dashboardProvider.dateFrom, null);
      expect(dashboardProvider.dateTo, null);
      expect(dashboardProvider.clubTypeFilter, null);
    });

    test('filtros combinados funcionan correctamente', () {
      // Aplicar filtro de fecha que incluya todas las sesiones
      final fourDaysAgo = now.subtract(const Duration(days: 4));
      dashboardProvider.setDateRange(fourDaysAgo, now);

      // Verificar que siguen mostrándose todas las sesiones
      expect(dashboardProvider.sessions.length, 2);

      // Añadir filtro de tipo de palo
      dashboardProvider.setClubTypeFilter(GolfClubType.lw);

      // Solo la segunda sesión tiene tiros con LW
      expect(dashboardProvider.sessions.length, 1);
      expect(dashboardProvider.sessions.first.date, threeDaysAgo);
    });
  });
}
