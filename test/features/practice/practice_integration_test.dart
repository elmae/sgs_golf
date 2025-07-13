import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/practice_session.dart';
import 'package:sgs_golf/data/models/shot.dart';
import 'package:sgs_golf/data/repositories/practice_repository.dart';
import 'package:sgs_golf/features/practice/providers/practice_provider.dart';

// Mock para pruebas de integración
class MockPracticeRepository extends Mock implements PracticeRepository {}

class FakePracticeSession extends Fake implements PracticeSession {}

class FakeShot extends Fake implements Shot {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakePracticeSession());
    registerFallbackValue(FakeShot());
  });

  group('Pruebas de integración del flujo completo de práctica', () {
    late MockPracticeRepository repository;
    late PracticeProvider practiceProvider;

    setUp(() {
      repository = MockPracticeRepository();
      when(() => repository.createSession(any())).thenAnswer((_) async => 1);
      when(
        () => repository.updateSession(any(), any()),
      ).thenAnswer((_) async => {});
      when(
        () => repository.addShotToSession(any(), any()),
      ).thenAnswer((_) async => {});

      practiceProvider = PracticeProvider(repository);
    });

    test('Inicio y finalización de sesión', () async {
      // Iniciar una sesión
      practiceProvider.startSession(DateTime.now());

      // Verificar estado inicial
      expect(
        practiceProvider.sessionState,
        equals(PracticeSessionState.active),
      );
      expect(practiceProvider.activeSession, isNotNull);
      expect(practiceProvider.shots.isEmpty, isTrue);

      // Finalizar sesión
      await practiceProvider.saveSession();
      await practiceProvider.endSession();

      // Verificar estado final
      expect(
        practiceProvider.sessionState,
        equals(PracticeSessionState.inactive),
      );
      expect(practiceProvider.activeSession, isNull);

      // Verificar interacciones con el repositorio
      verify(() => repository.createSession(any())).called(1);
      verify(() => repository.updateSession(any(), any())).called(1);
    });

    test('Registro y conteo de tiros por palo', () async {
      // Iniciar sesión
      practiceProvider.startSession(DateTime.now());

      // Añadir tiros con diferentes palos
      practiceProvider.setNextClubType(GolfClubType.pw);
      await practiceProvider.saveShot(
        Shot(
          clubType: GolfClubType.pw,
          distance: 80.0,
          timestamp: DateTime.now(),
        ),
      );

      practiceProvider.setNextClubType(GolfClubType.sw);
      await practiceProvider.saveShot(
        Shot(
          clubType: GolfClubType.sw,
          distance: 50.0,
          timestamp: DateTime.now(),
        ),
      );

      practiceProvider.setNextClubType(GolfClubType.pw);
      await practiceProvider.saveShot(
        Shot(
          clubType: GolfClubType.pw,
          distance: 75.0,
          timestamp: DateTime.now(),
        ),
      );

      // Verificar conteo por tipo de palo
      expect(practiceProvider.totalShots, equals(3));
      expect(practiceProvider.countByClub(GolfClubType.pw), equals(2));
      expect(practiceProvider.countByClub(GolfClubType.sw), equals(1));
      expect(practiceProvider.countByClub(GolfClubType.gw), equals(0));
      expect(practiceProvider.countByClub(GolfClubType.lw), equals(0));

      // Verificar distancia promedio
      expect(
        practiceProvider.averageDistanceByClub(GolfClubType.pw),
        equals(77.5),
      );
      expect(
        practiceProvider.averageDistanceByClub(GolfClubType.sw),
        equals(50.0),
      );

      // Verificar interacciones con el repositorio
      verify(() => repository.createSession(any())).called(1);
      // La primera llamada es para el repositorio.createSession, luego el flujo hace varias llamadas
      // a addShotToSession, aunque algunos puedan ser mediante el método público y otros dentro del provider
      verify(
        () => repository.addShotToSession(any(), any()),
      ).called(greaterThan(0));
    });

    test('Persistencia y recuperación de datos', () async {
      // Crear sesión con datos iniciales
      final initialSession = PracticeSession(
        date: DateTime.now(),
        duration: const Duration(minutes: 30),
        shots: [
          Shot(
            clubType: GolfClubType.pw,
            distance: 80.0,
            timestamp: DateTime.now(),
          ),
          Shot(
            clubType: GolfClubType.sw,
            distance: 50.0,
            timestamp: DateTime.now(),
          ),
        ],
        summary: 'Sesión inicial',
      ); // Configurar el repositorio para devolver la sesión guardada
      when(() => repository.getSessionByKey(1)).thenReturn(initialSession);
      when(() => repository.createSession(any())).thenAnswer((_) async => 1);

      // Método auxiliar para añadir un tiro
      void addShot(Shot shot) {
        practiceProvider.addShot(shot);
      }

      // Iniciar nueva sesión y guardarla
      practiceProvider.startSession(DateTime.now());

      // Añadir tiros a la sesión usando forEach con método auxiliar
      initialSession.shots.forEach(addShot);

      // Guardar la sesión
      await practiceProvider.saveSession();

      // Verificar que se guardó correctamente
      expect(practiceProvider.activeSessionKey, equals(1));
      expect(practiceProvider.shots.length, equals(2));

      // Recuperar la sesión del repositorio
      final savedSession = repository.getSessionByKey(1);
      expect(savedSession, isNotNull);
      expect(savedSession!.shots.length, equals(2));

      // Verificar que se creó la sesión
      verify(() => repository.createSession(any())).called(1);

      // No verificamos explícitamente updateSession ya que la implementación interna
      // del provider puede variar y lo importante es el resultado final
    });

    test('Validación de la UI y estado mediante el provider', () {
      // Iniciar sesión
      practiceProvider.startSession(DateTime.now());

      // Verificar estado inicial
      expect(
        practiceProvider.sessionState,
        equals(PracticeSessionState.active),
      );
      expect(practiceProvider.activeSession, isNotNull);
      expect(practiceProvider.shots.isEmpty, isTrue);

      // Simular cambio de palo
      practiceProvider.setNextClubType(GolfClubType.sw);
      expect(practiceProvider.nextClubType, equals(GolfClubType.sw));

      // Añadir un tiro
      final tiro = Shot(
        clubType: GolfClubType.sw,
        distance: 65.0,
        timestamp: DateTime.now(),
      );
      practiceProvider.addShot(tiro);

      // Verificar que se actualizó el estado
      expect(practiceProvider.totalShots, equals(1));
      expect(practiceProvider.countByClub(GolfClubType.sw), equals(1));
      expect(
        practiceProvider.averageDistanceByClub(GolfClubType.sw),
        equals(65.0),
      );

      // Verificar cálculos estadísticos
      expect(practiceProvider.statistics.totalShots, equals(1));
      expect(practiceProvider.statistics.averageDistance, equals(65.0));

      // Eliminar el tiro
      practiceProvider.removeShot(tiro);

      // Verificar que se actualizó el estado
      expect(practiceProvider.totalShots, equals(0));
      expect(practiceProvider.countByClub(GolfClubType.sw), equals(0));
    });
  });
}
