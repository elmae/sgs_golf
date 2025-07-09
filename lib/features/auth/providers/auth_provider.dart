/// Provider responsable de gestionar el estado y las operaciones de autenticación de usuarios en SGS Golf, incluyendo inicio de sesión, cierre de sesión y mantenimiento de la sesión activa.
/// Maneja los estados de autenticación y expone métodos para login, logout y registro.
/// Usa Provider (ChangeNotifier) y se integra con AuthRepository.
///
/// Estados posibles:
/// - Autenticado: usuario no nulo.
/// - No autenticado: usuario nulo.
/// - Cargando: operación en progreso.
/// - Error: mensaje de error disponible.
library;

import 'package:flutter/material.dart';
import 'package:sgs_golf/data/models/user.dart';
import 'package:sgs_golf/data/repositories/auth_repository.dart';

/// Enum para los estados de autenticación.
enum AuthStatus { authenticated, unauthenticated, loading, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  User? _usuario;
  AuthStatus _estado = AuthStatus.unauthenticated;
  String? _mensajeError;

  /// Constructor, permite inyectar un AuthRepository (útil para tests).
  AuthProvider({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository() {
    _verificarSesion();
  }

  /// Usuario autenticado actual, o null si no autenticado.
  User? get usuario => _usuario;

  /// Estado actual de autenticación.
  /// Getter esperado por los widgets: estado actual.
  AuthStatus get status => _estado;

  /// Getter esperado por los widgets: mensaje de error.
  String? get errorMessage => _mensajeError;

  /// Indica si hay una operación en progreso.
  bool get cargando => _estado == AuthStatus.loading;

  /// Indica si hay un usuario autenticado.
  bool get autenticado => _estado == AuthStatus.authenticated && _usuario != null;

  /// Intenta iniciar sesión con email y contraseña.
  Future<void> login(String email, String password) async {
    _setEstado(AuthStatus.loading);
    try {
      final user = await _authRepository.login(email, password);
      if (user != null) {
        _usuario = user;
        _setEstado(AuthStatus.authenticated);
      } else {
        _setError('Credenciales incorrectas');
      }
    } catch (e) {
      _setError(_mensajeDeError(e));
    }
  }

  /// Registra un nuevo usuario y lo autentica.
  Future<void> register(String nombre, String email, String password) async {
    _setEstado(AuthStatus.loading);
    try {
      final user = await _authRepository.register(nombre, email, password);
      _usuario = user;
      _setEstado(AuthStatus.authenticated);
    } catch (e) {
      _setError(_mensajeDeError(e));
    }
  }

  /// Cierra la sesión del usuario.
  Future<void> logout() async {
    _setEstado(AuthStatus.loading);
    try {
      await _authRepository.logout();
      _usuario = null;
      _setEstado(AuthStatus.unauthenticated);
    } catch (e) {
      _setError(_mensajeDeError(e));
    }
  }

  /// Verifica si hay una sesión activa al inicializar el provider.
  Future<void> _verificarSesion() async {
    _setEstado(AuthStatus.loading);
    try {
      final user = await _authRepository.obtenerUsuarioAutenticado();
      if (user != null) {
        _usuario = user;
        _setEstado(AuthStatus.authenticated);
      } else {
        _setEstado(AuthStatus.unauthenticated);
      }
    } catch (e) {
      _setError(_mensajeDeError(e));
    }
  }

  /// Establece el estado y notifica listeners.
  void _setEstado(AuthStatus estado) {
    _estado = estado;
    if (estado != AuthStatus.error) _mensajeError = null;
    notifyListeners();
  }

  /// Establece el error y notifica listeners.
  void _setError(String mensaje) {
    _estado = AuthStatus.error;
    _mensajeError = mensaje;
    notifyListeners();
  }

  /// Extrae el mensaje de error de una excepción.
  String _mensajeDeError(Object e) {
    if (e is InvalidUserException) return e.message;
    return 'Error inesperado: ${e.toString()}';
  }
}