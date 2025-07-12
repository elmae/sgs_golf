import 'package:flutter_test/flutter_test.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/practice_session.dart';
import 'package:sgs_golf/data/models/shot.dart';
import 'package:sgs_golf/data/repositories/practice_repository.dart';
import 'package:sgs_golf/features/practice/providers/practice_provider.dart';

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
  group('PracticeProvider Statistics Tests', () {
    late PracticeProvider provider;
    late FakePracticeRepository fakeRepository;

    setUp(() {
      fakeRepository = FakePracticeRepository();
      provider = PracticeProvider(fakeRepository);
    });

    test('Initial statistics should be empty', () {
      expect(provider.statistics.totalShots, 0);
      expect(provider.statistics.averageDistance, 0);
      expect(provider.statistics.shotCounts[GolfClubType.pw], 0);
    });

    test('Statistics should update when adding shots', () {
      // Iniciar una sesión
      provider.startSession(DateTime.now());

      // Agregar un tiro
      final shot1 = Shot(
        clubType: GolfClubType.pw,
        distance: 100.0,
        timestamp: DateTime.now(),
      );
      provider.addShot(shot1);

      // Verificar que las estadísticas se actualizan
      expect(provider.statistics.totalShots, 1);
      expect(provider.statistics.totalDistance, 100.0);
      expect(provider.statistics.averageDistance, 100.0);
      expect(provider.statistics.shotCounts[GolfClubType.pw], 1);
      expect(provider.statistics.averageDistanceByClub[GolfClubType.pw], 100.0);

      // Agregar un segundo tiro con un palo diferente
      final shot2 = Shot(
        clubType: GolfClubType.sw,
        distance: 80.0,
        timestamp: DateTime.now(),
      );
      provider.addShot(shot2);

      // Verificar que las estadísticas se actualizan correctamente
      expect(provider.statistics.totalShots, 2);
      expect(provider.statistics.totalDistance, 180.0);
      expect(provider.statistics.averageDistance, 90.0);
      expect(provider.statistics.shotCounts[GolfClubType.pw], 1);
      expect(provider.statistics.shotCounts[GolfClubType.sw], 1);
      expect(provider.statistics.averageDistanceByClub[GolfClubType.sw], 80.0);
    });

    test('Statistics should reset when ending session', () async {
      // Iniciar una sesión
      provider.startSession(DateTime.now());

      // Agregar un tiro
      final shot = Shot(
        clubType: GolfClubType.pw,
        distance: 100.0,
        timestamp: DateTime.now(),
      );
      provider.addShot(shot);

      // Verificar que las estadísticas se actualizan
      expect(provider.statistics.totalShots, 1);

      // Finalizar la sesión
      await provider.endSession();

      // Verificar que las estadísticas se han reiniciado
      expect(provider.statistics.totalShots, 0);
      expect(provider.statistics.averageDistance, 0);
      expect(provider.statistics.shotCounts[GolfClubType.pw], 0);
    });

    test('Statistics should update when removing shots', () {
      // Iniciar una sesión
      provider.startSession(DateTime.now());

      // Agregar dos tiros
      final shot1 = Shot(
        clubType: GolfClubType.pw,
        distance: 100.0,
        timestamp: DateTime.now(),
      );
      final shot2 = Shot(
        clubType: GolfClubType.sw,
        distance: 80.0,
        timestamp: DateTime.now(),
      );

      provider.addShot(shot1);
      provider.addShot(shot2);

      // Verificar estadísticas iniciales
      expect(provider.statistics.totalShots, 2);
      expect(provider.statistics.totalDistance, 180.0);

      // Eliminar un tiro
      provider.removeShot(shot1);

      // Verificar que las estadísticas se actualizan correctamente
      expect(provider.statistics.totalShots, 1);
      expect(provider.statistics.totalDistance, 80.0);
      expect(provider.statistics.averageDistance, 80.0);
      expect(provider.statistics.shotCounts[GolfClubType.pw], 0);
      expect(provider.statistics.shotCounts[GolfClubType.sw], 1);
    });
  });
}
