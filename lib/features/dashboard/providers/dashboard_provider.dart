import 'package:flutter/material.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/practice_session.dart';
import 'package:sgs_golf/data/repositories/practice_repository.dart';

/// Opciones de ordenamiento para sesiones de práctica
enum SessionSortOption {
  /// Más reciente primero
  dateDesc,

  /// Más antigua primero
  dateAsc,

  /// Mayor duración primero
  durationDesc,

  /// Menor duración primero
  durationAsc,

  /// Mayor número de tiros primero
  shotsDesc,

  /// Menor número de tiros primero
  shotsAsc,
}

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
  List<PracticeSession> _allSessions = [];
  List<PracticeSession> _filteredSessions = [];
  bool _isLoading = false;
  String? _error;

  // Filtros y ordenamiento
  DateTime? _dateFrom;
  DateTime? _dateTo;
  GolfClubType? _clubTypeFilter;
  SessionSortOption _sortOption = SessionSortOption.dateDesc;

  /// Constructor que recibe el repositorio de práctica como dependencia
  DashboardProvider(this._practiceRepository) {
    loadSessions();
  }

  /// Listado completo de sesiones
  List<PracticeSession> get allSessions => _allSessions;

  /// Listado de sesiones filtradas y ordenadas
  List<PracticeSession> get sessions => _filteredSessions;

  /// Estado de carga de datos
  bool get isLoading => _isLoading;

  /// Error durante la carga de datos (si existe)
  String? get error => _error;

  /// Opción de ordenamiento actual
  SessionSortOption get sortOption => _sortOption;

  /// Filtro de fecha inicial
  DateTime? get dateFrom => _dateFrom;

  /// Filtro de fecha final
  DateTime? get dateTo => _dateTo;

  /// Filtro por tipo de palo
  GolfClubType? get clubTypeFilter => _clubTypeFilter;

  /// Carga las sesiones desde el repositorio
  Future<void> loadSessions() async {
    _setLoading(true);
    try {
      _allSessions = _practiceRepository.getAllSessions();
      _applyFiltersAndSort(); // Aplicar filtros y ordenamiento
      _error = null;
    } catch (e) {
      _error = 'Error al cargar sesiones: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  /// Establece el orden de las sesiones
  void setSortOption(SessionSortOption option) {
    _sortOption = option;
    _applyFiltersAndSort();
    notifyListeners();
  }

  /// Filtra sesiones por rango de fechas
  void setDateRange(DateTime? from, DateTime? to) {
    _dateFrom = from;
    _dateTo = to;
    _applyFiltersAndSort();
    notifyListeners();
  }

  /// Filtra sesiones por tipo de palo
  void setClubTypeFilter(GolfClubType? clubType) {
    _clubTypeFilter = clubType;
    _applyFiltersAndSort();
    notifyListeners();
  }

  /// Elimina todos los filtros aplicados
  void clearFilters() {
    _dateFrom = null;
    _dateTo = null;
    _clubTypeFilter = null;
    _applyFiltersAndSort();
    notifyListeners();
  }

  /// Aplica filtros y ordenamiento a las sesiones
  void _applyFiltersAndSort() {
    // Primero aplicamos los filtros
    _filteredSessions = List.from(_allSessions);

    // Filtrar por fecha desde
    if (_dateFrom != null) {
      _filteredSessions = _filteredSessions
          .where((session) => session.date.isAfter(_dateFrom!))
          .toList();
    }

    // Filtrar por fecha hasta
    if (_dateTo != null) {
      _filteredSessions = _filteredSessions
          .where(
            (session) =>
                session.date.isBefore(_dateTo!.add(const Duration(days: 1))),
          )
          .toList();
    }

    // Filtrar por tipo de palo
    if (_clubTypeFilter != null) {
      _filteredSessions = _filteredSessions
          .where(
            (session) =>
                session.shots.any((shot) => shot.clubType == _clubTypeFilter),
          )
          .toList();
    }

    // Aplicar ordenamiento
    _filteredSessions.sort((a, b) {
      switch (_sortOption) {
        case SessionSortOption.dateDesc:
          return b.date.compareTo(a.date);
        case SessionSortOption.dateAsc:
          return a.date.compareTo(b.date);
        case SessionSortOption.durationDesc:
          return b.duration.compareTo(a.duration);
        case SessionSortOption.durationAsc:
          return a.duration.compareTo(b.duration);
        case SessionSortOption.shotsDesc:
          return b.totalShots.compareTo(a.totalShots);
        case SessionSortOption.shotsAsc:
          return a.totalShots.compareTo(b.totalShots);
      }
    });
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
  int get totalSessions => _allSessions.length;

  /// Calcula el número total de tiros en todas las sesiones
  int get totalShots =>
      _allSessions.fold(0, (sum, session) => sum + session.totalShots);

  /// Calcula el promedio de tiros por sesión
  double get averageShotsPerSession =>
      totalSessions > 0 ? totalShots / totalSessions : 0;

  // Métodos privados
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
