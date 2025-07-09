import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:sgs_golf/data/models/user.dart';
import 'package:sgs_golf/data/repositories/auth_repository.dart';

void main() {
  late AuthRepository authRepository;

  setUpAll(() {
    Hive.registerAdapter(UserAdapter());
  });

  setUp(() async {
    await setUpTestHive();
    authRepository = AuthRepository();
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  group('AuthRepository', () {
    // [x] Probar el método register() con datos de usuario válidos.
    // [x] Probar el método register() intentando registrar un usuario que ya existe.
    // [x] Probar el método login() con credenciales correctas.
    // [x] Probar el método login() con credenciales incorrectas (usuario no encontrado o contraseña errónea).
    // [x] Probar el método logout() para asegurar que la sesión se cierre correctamente.
    // [x] Probar el método updateProfile() para verificar que los datos del usuario se actualizan.

    test('register should save a user', () async {
      final result = await authRepository.register(
        'Test User',
        'test@example.com',
        'Password123',
      );
      expect(result.name, 'Test User');
      expect(result.email, 'test@example.com');
      // Check that the user is persisted
      final userBox = await Hive.openBox<User>('users');
      final found = userBox.values.firstWhere(
        (u) => u.email == 'test@example.com',
      );
      expect(found, isNotNull);
    });

    test('register should throw an exception if user already exists', () async {
      await authRepository.register(
        'Test User',
        'test@example.com',
        'Password123',
      );
      expect(
        () => authRepository.register(
          'Test User',
          'test@example.com',
          'Password123',
        ),
        throwsException,
      );
    });

    test('login should return a user if credentials are correct', () async {
      await authRepository.register(
        'Test User',
        'test@example.com',
        'Password123',
      );
      final result = await authRepository.login(
        'test@example.com',
        'Password123',
      );
      expect(result, isNotNull);
      expect(result!.email, 'test@example.com');
    });

    test('login should return null if user is not found', () async {
      final result = await authRepository.login(
        'notfound@example.com',
        'Password123',
      );
      expect(result, isNull);
    });

    test('login should return null if password is not correct', () async {
      await authRepository.register(
        'Test User',
        'test@example.com',
        'Password123',
      );
      final result = await authRepository.login(
        'test@example.com',
        'wrong_password',
      );
      expect(result, isNull);
    });

    test('logout should clear the session', () async {
      await authRepository.register(
        'Test User',
        'test@example.com',
        'Password123',
      );
      await authRepository.logout();
      final sessionBox = await Hive.openBox('session');
      expect(sessionBox.get('current_user_id'), isNull);
    });

    test('updateProfile should update the user', () async {
      final user = await authRepository.register(
        'Test User',
        'test@example.com',
        'Password123',
      );
      final updatedUser = User(
        id: user.id,
        name: 'Updated User',
        email: user.email,
        password: user.password,
      );
      await authRepository.updateProfile(updatedUser);
      final userBox = await Hive.openBox<User>('users');
      final found = userBox.get(user.id);
      expect(found!.name, 'Updated User');
    });
  });
}
