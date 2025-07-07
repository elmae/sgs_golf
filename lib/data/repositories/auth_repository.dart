import 'package:hive/hive.dart';
import 'package:sgs_golf/data/models/user.dart';
import 'package:sgs_golf/data/services/auth_service.dart';

class AuthRepository {
  static const String _userBoxName = 'users';
  static const String _sessionBoxName = 'session';
  static const String _sessionKey = 'current_user_id';

  final AuthService _authService;

  AuthRepository({AuthService? authService})
    : _authService = authService ?? AuthService();

  /// Registra un nuevo usuario, valida, hashea y guarda en Hive.
  Future<User> register(String name, String email, String password) async {
    if (!AuthService.isValidEmail(email)) {
      throw InvalidUserException('Email inválido');
    }
    if (!AuthService.isValidPassword(password)) {
      throw InvalidUserException('Contraseña inválida');
    }
    final userBox = await Hive.openBox<User>(_userBoxName);

    // Verifica si ya existe un usuario con ese email
    final exists = userBox.values.any((u) => u.email == email);
    if (exists) {
      throw InvalidUserException('El email ya está registrado');
    }

    final hashedPassword = _authService.hashPassword(password);
    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      password: hashedPassword,
    );
    user.validate();
    await userBox.put(user.id, user);

    // Guarda sesión local
    await _guardarUsuarioAutenticado(user);

    return user;
  }

  /// Guarda el usuario autenticado en la sesión.
  Future<void> _guardarUsuarioAutenticado(User user) async {
    final sessionBox = await Hive.openBox(_sessionBoxName);
    await sessionBox.put(_sessionKey, user.id);
  }

  /// Obtiene el usuario autenticado actual, o null si no hay sesión.
  Future<User?> obtenerUsuarioAutenticado() async {
    final sessionBox = await Hive.openBox(_sessionBoxName);
    final userId = sessionBox.get(_sessionKey);
    if (userId == null) return null;
    final userBox = await Hive.openBox<User>(_userBoxName);
    return userBox.get(userId);
  }

  /// Elimina la sesión del usuario autenticado.
  Future<void> eliminarUsuarioAutenticado() async {
    final sessionBox = await Hive.openBox(_sessionBoxName);
    await sessionBox.delete(_sessionKey);
  }

  /// Inicia sesión, valida credenciales y retorna usuario si es correcto.
  Future<User?> login(String email, String password) async {
    final userBox = await Hive.openBox<User>(_userBoxName);
    User? user;
    for (final u in userBox.values) {
      if (u.email == email) {
        user = u;
        break;
      }
    }
    if (user == null) return null;
    if (!_authService.verifyPassword(password, user.password)) return null;

    // Guarda sesión local
    await _guardarUsuarioAutenticado(user);

    return user;
  }

  /// Cierra sesión eliminando la sesión local.
  Future<void> logout() async {
    final sessionBox = await Hive.openBox(_sessionBoxName);
    await sessionBox.delete(_sessionKey);
  }

  /// Actualiza los datos del usuario en Hive.
  Future<User> updateProfile(User user) async {
    user.validate();
    final userBox = await Hive.openBox<User>(_userBoxName);
    await userBox.put(user.id, user);
    return user;
  }

  /// Obtiene el usuario actualmente autenticado (opcional).
  Future<User?> getCurrentUser() async {
    final sessionBox = await Hive.openBox(_sessionBoxName);
    final userId = sessionBox.get(_sessionKey);
    if (userId == null) return null;
    final userBox = await Hive.openBox<User>(_userBoxName);
    return userBox.get(userId);
  }
}
