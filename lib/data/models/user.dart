import 'package:hive/hive.dart';

part 'user.g.dart';

class InvalidUserException implements Exception {
  final String message;
  InvalidUserException(this.message);

  @override
  String toString() => 'InvalidUserException: $message';
}

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String email;

  @HiveField(3)
  String password; // Should be hashed

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  /// Valida los campos del usuario.
  void validate() {
    if (id.trim().isEmpty) {
      throw InvalidUserException('El ID no puede estar vacío.');
    }
    if (name.trim().isEmpty) {
      throw InvalidUserException('El nombre no puede estar vacío.');
    }
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    if (!emailRegex.hasMatch(email)) {
      throw InvalidUserException('El correo electrónico no es válido.');
    }
    if (password.length < 6) {
      throw InvalidUserException(
        'La contraseña debe tener al menos 6 caracteres.',
      );
    }
  }
}
