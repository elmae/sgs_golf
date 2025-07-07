import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

/// Servicio de autenticación local para SGS Golf.
///
/// Encapsula la lógica de hash y validación de contraseñas, así como validaciones
/// de formato para email y contraseña. No incluye lógica de UI ni persistencia.
///
/// Ejemplo de uso:
/// ```dart
/// final auth = AuthService();
/// final hash = auth.hashPassword('MiContraseña123');
/// final isValid = auth.verifyPassword('MiContraseña123', hash);
/// final emailOk = AuthService.isValidEmail('usuario@ejemplo.com');
/// final passOk = AuthService.isValidPassword('MiContraseña123');
/// ```
class AuthService {
  /// Genera un hash seguro de la contraseña usando SHA-256 y un salt aleatorio.
  /// El formato del hash es: `salt:hash`
  ///
  /// - [password]: Contraseña en texto plano.
  /// - Retorna: Cadena con salt y hash concatenados.
  String hashPassword(String password) {
    final salt = _generateSalt();
    final bytes = utf8.encode('$salt$password');
    final digest = sha256.convert(bytes);
    return '$salt:${digest.toString()}';
  }

  /// Verifica si la contraseña coincide con el hash almacenado.
  ///
  /// - [password]: Contraseña en texto plano.
  /// - [hash]: Cadena con formato `salt:hash`.
  /// - Retorna: true si la contraseña es válida.
  bool verifyPassword(String password, String hash) {
    final parts = hash.split(':');
    if (parts.length != 2) return false;
    final salt = parts[0];
    final hashToCompare = parts[1];
    final bytes = utf8.encode('$salt$password');
    final digest = sha256.convert(bytes);
    return digest.toString() == hashToCompare;
  }

  /// Valida si el email tiene un formato válido.
  ///
  /// - [email]: Email a validar.
  /// - Retorna: true si el formato es válido.
  static bool isValidEmail(String email) {
    final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    return regex.hasMatch(email);
  }

  /// Valida si la contraseña cumple con los requisitos mínimos:
  /// al menos 8 caracteres, una mayúscula y un número.
  ///
  /// - [password]: Contraseña a validar.
  /// - Retorna: true si cumple los requisitos.
  static bool isValidPassword(String password) {
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$');
    return regex.hasMatch(password);
  }

  /// Genera un salt aleatorio de 16 caracteres.
  ///
  /// - Retorna: Cadena aleatoria para usar como salt.
  String _generateSalt() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    return List.generate(16, (_) => chars[rand.nextInt(chars.length)]).join();
  }
}
