import 'package:flutter/material.dart';
import 'package:sgs_golf/data/models/practice_session.dart';
import 'package:sgs_golf/data/repositories/practice_repository.dart';

/// Provider que gestiona el estado y los datos para la pantalla de dashboard
///
/// Este provider es responsable de obtener y mantener:
/// - Lista de sesiones de práctica
/// - Filtrado y ordenamiento de sesiones
/// - Estadísticas resumidas para el dashboard
///
/// Se integra con PracticeRepository para acceder a los datos persistentes
class DashboardProvider extends ChangeNotifier {
  final PracticeRepository _practiceRepository;
  List<PracticeSession> _sessions = [];
  bool _isLoading = false;
  String? _error;

  /// Constructor que recibe el repositorio de práctica como dependencia
  DashboardProvider(this._practiceRepository) {
    loadSessions();
  }

  /// Listado actual de sesiones
  List<PracticeSession> get sessions => _sessions;

  /// Estado de carga de datos
  bool get isLoading => _isLoading;

  /// Error durante la carga de datos (si existe)
  String? get error => _error;

  /// Carga las sesiones desde el repositorio
  Future<void> loadSessions() async {
    _setLoading(true);
    try {
      _sessions = _practiceRepository.getAllSessions();
      _sessions.sort(
        (a, b) => b.date.compareTo(a.date),
      ); // Ordenar por fecha (más reciente primero)
      _error = null;
    } catch (e) {
      _error = 'Error al cargar sesiones: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  /// Refresca los datos del dashboard
  Future<void> refreshData() async {
    await loadSessions();
  }

  /// Elimina una sesión
  Future<void> deleteSession(int sessionKey) async {
    _setLoading(true);
    try {
      await _practiceRepository.deleteSession(sessionKey);
      await loadSessions(); // Recargar la lista después de eliminar
    } catch (e) {
      _error = 'Error al eliminar sesión: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  /// Calcula el número total de sesiones
  int get totalSessions => _sessions.length;

  /// Calcula el número total de tiros en todas las sesiones
  int get totalShots =>
      _sessions.fold(0, (sum, session) => sum + session.totalShots);

  /// Calcula el promedio de tiros por sesión
  double get averageShotsPerSession =>
      totalSessions > 0 ? totalShots / totalSessions : 0;

  // Métodos privados
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
