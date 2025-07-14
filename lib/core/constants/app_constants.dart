/// Constantes globales de la aplicación SGS Golf
///
/// Define valores constantes utilizados en toda la aplicación,
/// como nombres de colecciones de Hive, límites de la aplicación,
/// y otras constantes compartidas.
class AppConstants {
  /// Clave para almacenar la sesión activa en Hive
  static const String activeSessionKey = 'active_session';

  /// Clave para almacenar el usuario actual en Hive
  static const String currentUserKey = 'current_user';

  /// Nombre de la colección Hive para sesiones de práctica
  static const String practiceSessionsBoxName = 'practice_sessions';

  /// Nombre de la colección Hive para usuarios
  static const String usersBoxName = 'users';

  /// Distancia mínima para un tiro válido (en metros)
  static const double minShotDistance = 1.0;

  /// Distancia máxima para un tiro válido (en metros)
  static const double maxShotDistance = 200.0;

  /// Duración máxima para una sesión de práctica (en horas)
  static const int maxSessionDurationHours = 5;

  /// Número máximo de tiros por sesión (límite técnico)
  static const int maxShotsPerSession = 1000;
}
