import 'package:flutter/material.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/practice_session.dart';
import 'package:sgs_golf/data/models/practice_session_ext.dart';
import 'package:sgs_golf/data/models/session_statistics.dart';
import 'package:sgs_golf/data/models/shot.dart';
import 'package:sgs_golf/data/repositories/practice_repository.dart';

/// Enum que representa los estados posibles de la sesión de práctica
enum PracticeSessionState {
  /// No hay una sesión activa
  inactive,

  /// La sesión está activa y se están registrando tiros
  active,

  /// La sesión está en pausa (por ejemplo, el usuario está descansando)
  paused,

  /// La sesión está siendo guardada
  saving,

  /// Ha ocurrido un error en la sesión
  error,
}

/// Provider que gestiona el estado de la sesión de práctica activa.
///
/// Mantiene el estado de la sesión, la lista de tiros y permite la actualización
/// reactiva de la interfaz de usuario.
class PracticeProvider extends ChangeNotifier {
  /// Club seleccionado para el siguiente disparo en la sesión activa.
  GolfClubType? _nextClubType;
  GolfClubType? get nextClubType => _nextClubType;

  /// Estado actual de la sesión de práctica
  PracticeSessionState _sessionState = PracticeSessionState.inactive;
  PracticeSessionState get sessionState => _sessionState;

  /// Mensaje de error si hay alguno
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Repositorio para guardar las sesiones
  final PracticeRepository repository;

  /// Sesión activa actual
  PracticeSession? _activeSession;

  /// Clave de la sesión activa en el repositorio
  int? _activeSessionKey;

  /// Duración acumulada de la sesión
  Duration _accumulatedDuration = Duration.zero;

  /// Tiempo de inicio de la sesión actual (usado para calcular la duración)
  DateTime? _sessionStartTime;

  /// Estadísticas calculadas en tiempo real
  SessionStatistics _statistics = SessionStatistics.empty();

  PracticeProvider(this.repository) {
    // Iniciar timer para actualizar las estadísticas cada 10 segundos cuando la sesión está activa
    _setupPeriodicStatisticsUpdate();
  }

  /// Configura la actualización periódica de estadísticas
  void _setupPeriodicStatisticsUpdate() {
    // Usar un Future.delayed recursivo para actualizar cada 10 segundos
    Future.delayed(const Duration(seconds: 10), () {
      // Solo actualizar si la sesión está activa
      if (_sessionState == PracticeSessionState.active) {
        _calculateStatistics();
        notifyListeners();
      }

      // Volver a programar la próxima actualización
      if (_sessionState != PracticeSessionState.inactive) {
        _setupPeriodicStatisticsUpdate();
      }
    });
  }

  /// Obtiene las estadísticas en tiempo real de la sesión actual
  SessionStatistics get statistics => _statistics;

  /// Obtiene la sesión activa actual
  PracticeSession? get activeSession => _activeSession;

  /// Obtiene la clave de la sesión activa en el repositorio
  int? get activeSessionKey => _activeSessionKey;

  /// Obtiene la lista de tiros de la sesión actual
  List<Shot> get shots => _activeSession?.shots ?? [];

  /// Obtiene la duración total de la sesión activa
  Duration get sessionDuration {
    if (_activeSession == null) return Duration.zero;

    final baseDuration = _accumulatedDuration;
    if (_sessionStartTime != null) {
      return baseDuration + DateTime.now().difference(_sessionStartTime!);
    }
    return baseDuration;
  }

  /// Inicia una nueva sesión de práctica
  void startSession(DateTime date) {
    _activeSession = PracticeSession(
      date: date,
      duration: Duration.zero,
      shots: const [],
      summary: '',
    );
    _activeSessionKey = null;
    _sessionState = PracticeSessionState.active;
    _sessionStartTime = DateTime.now();
    _accumulatedDuration = Duration.zero;
    _errorMessage = null;
    _calculateStatistics();
    notifyListeners();
  }

  /// Pausa la sesión activa (útil si el usuario está tomando un descanso)
  void pauseSession() {
    if (_sessionState == PracticeSessionState.active &&
        _sessionStartTime != null) {
      _accumulatedDuration += DateTime.now().difference(_sessionStartTime!);
      _sessionStartTime = null;
      _sessionState = PracticeSessionState.paused;
      notifyListeners();
    }
  }

  /// Reanuda una sesión pausada
  void resumeSession() {
    if (_sessionState == PracticeSessionState.paused) {
      _sessionStartTime = DateTime.now();
      _sessionState = PracticeSessionState.active;
      notifyListeners();
    }
  }

  /// Guarda la sesión actual en el repositorio
  Future<void> saveSession() async {
    if (_activeSession != null) {
      try {
        _sessionState = PracticeSessionState.saving;
        notifyListeners();

        // Actualiza la duración antes de guardar
        final updatedSession = _activeSession!.copyWith(
          duration: sessionDuration,
        );

        if (_activeSessionKey == null) {
          _activeSessionKey = await repository.createSession(updatedSession);
        } else {
          await repository.updateSession(_activeSessionKey!, updatedSession);
        }

        _activeSession = updatedSession;
        _sessionState = PracticeSessionState.active;
        _calculateStatistics();
        notifyListeners();
      } catch (e) {
        _sessionState = PracticeSessionState.error;
        _errorMessage = 'Error al guardar la sesión: $e';
        notifyListeners();
        rethrow;
      }
    }
  }

  /// Permite seleccionar el club para el siguiente disparo.
  void setNextClubType(GolfClubType clubType) {
    _nextClubType = clubType;
    notifyListeners();
  }

  /// Agrega un tiro a la sesión activa
  void addShot(Shot shot) {
    if (_activeSession != null) {
      _activeSession = _activeSession!.copyWith(
        shots: List<Shot>.from(_activeSession!.shots)..add(shot),
      );
      _calculateStatistics();
      notifyListeners();
    }
  }

  /// Elimina un tiro específico de la sesión activa
  void removeShot(Shot shot) {
    if (_activeSession != null && _activeSession!.shots.contains(shot)) {
      _activeSession = _activeSession!.copyWith(
        shots: List<Shot>.from(_activeSession!.shots)..remove(shot),
      );
      _calculateStatistics();
      notifyListeners();
    }
  }

  /// Guarda un tiro en la sesión activa y lo persiste en el repositorio
  Future<void> saveShot(Shot shot) async {
    if (_activeSession != null) {
      addShot(shot);
      try {
        if (_activeSessionKey == null) {
          await saveSession();
        } else {
          await repository.addShotToSession(_activeSessionKey!, shot);
        }
      } catch (e) {
        _sessionState = PracticeSessionState.error;
        _errorMessage = 'Error al guardar el tiro: $e';
        notifyListeners();
        rethrow;
      }
    }
  }

  /// Número total de tiros en la sesión activa
  int get totalShots => _activeSession?.totalShots ?? 0;

  /// Distancia total de todos los tiros de la sesión activa
  double get totalDistance => _activeSession?.totalDistance ?? 0.0;

  /// Cuenta los tiros por tipo de palo
  int countByClub(GolfClubType clubType) =>
      _activeSession?.countByClub(clubType) ?? 0;

  /// Promedio de distancia por tipo de palo
  double averageDistanceByClub(GolfClubType clubType) =>
      _activeSession?.averageDistanceByClub(clubType) ?? 0.0;

  /// Calcula las estadísticas en tiempo real de la sesión actual
  void _calculateStatistics() {
    if (_activeSession == null || _activeSession!.shots.isEmpty) {
      _statistics = SessionStatistics.empty();
      return;
    }

    final shots = _activeSession!.shots;
    final totalShots = shots.length;
    final totalDistance = shots.fold<double>(0, (sum, s) => sum + s.distance);
    final averageDistance = totalShots > 0 ? totalDistance / totalShots : 0.0;

    // Calcular estadísticas por tipo de palo
    final shotCounts = <GolfClubType, int>{};
    final totalDistanceByClub = <GolfClubType, double>{};
    final averageDistanceByClub = <GolfClubType, double>{};

    for (final club in GolfClubType.values) {
      final clubShots = shots.where((s) => s.clubType == club).toList();
      final clubCount = clubShots.length;
      shotCounts[club] = clubCount;

      final clubTotalDistance = clubShots.fold<double>(
        0,
        (sum, s) => sum + s.distance,
      );
      totalDistanceByClub[club] = clubTotalDistance;

      averageDistanceByClub[club] = clubCount > 0
          ? clubTotalDistance / clubCount
          : 0.0;
    }

    // Calcular tasa de tiros por minuto
    final durationInMinutes = sessionDuration.inSeconds / 60.0;
    final shotsPerMinute = durationInMinutes > 0
        ? totalShots / durationInMinutes
        : null;

    _statistics = SessionStatistics(
      totalShots: totalShots,
      totalDistance: totalDistance,
      averageDistance: averageDistance,
      shotCounts: shotCounts,
      totalDistanceByClub: totalDistanceByClub,
      averageDistanceByClub: averageDistanceByClub,
      durationInMinutes: durationInMinutes,
      shotsPerMinute: shotsPerMinute,
    );
  }

  /// Actualiza el resumen de la sesión
  void updateSummary(String summary) {
    if (_activeSession != null) {
      _activeSession = _activeSession!.copyWith(summary: summary);
      notifyListeners();
    }
  }

  /// Limpia el estado de error y restablece el estado de la sesión si está en error
  void clearError() {
    if (_sessionState == PracticeSessionState.error) {
      _errorMessage = null;
      _sessionState = _activeSession != null
          ? PracticeSessionState.active
          : PracticeSessionState.inactive;
      notifyListeners();
    }
  }

  /// Finaliza la sesión actual, guardándola y liberando los recursos
  Future<void> endSession() async {
    try {
      if (_activeSession != null) {
        // Guarda la sesión con la duración final
        await saveSession();
      }
    } finally {
      _activeSession = null;
      _activeSessionKey = null;
      _sessionState = PracticeSessionState.inactive;
      _sessionStartTime = null;
      _accumulatedDuration = Duration.zero;
      _errorMessage = null;
      _statistics = SessionStatistics.empty();
      notifyListeners();
    }
  }

  /// Descarta la sesión actual sin guardarla
  void discardSession() {
    _activeSession = null;
    _activeSessionKey = null;
    _sessionState = PracticeSessionState.inactive;
    _sessionStartTime = null;
    _accumulatedDuration = Duration.zero;
    _errorMessage = null;
    _statistics = SessionStatistics.empty();
    notifyListeners();
  }
}
