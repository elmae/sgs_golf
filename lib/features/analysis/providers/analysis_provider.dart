import 'package:flutter/material.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/practice_session.dart';
import 'package:sgs_golf/data/repositories/analytics_repository.dart';
import 'package:sgs_golf/data/repositories/practice_repository.dart';

class AnalysisProvider extends ChangeNotifier {
  final AnalyticsRepository analyticsRepository;
  final PracticeRepository practiceRepository;
  List<PracticeSession> _sessions = [];
  PracticeSession? _selectedSession;
  PracticeSession? _compareSession;
  bool _isLoading = false;
  String? _error;

  AnalysisProvider(this.analyticsRepository, this.practiceRepository);

  List<PracticeSession> get sessions => _sessions;
  PracticeSession? get selectedSession => _selectedSession;
  PracticeSession? get compareSession => _compareSession;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setSessions(List<PracticeSession> sessions) {
    _sessions = sessions;
    notifyListeners();
  }

  void selectSession(PracticeSession session) {
    _selectedSession = session;
    notifyListeners();
  }

  void selectCompareSession(PracticeSession? session) {
    _compareSession = session;
    notifyListeners();
  }

  Map<GolfClubType, double> get averageByClub {
    if (_selectedSession == null) return {};
    return analyticsRepository.averageDistanceByClub(_selectedSession!);
  }

  Map<GolfClubType, double> get consistencyByClub {
    if (_selectedSession == null) return {};
    return analyticsRepository.consistencyByClub(_selectedSession!);
  }

  Map<GolfClubType, double> get comparisonByClub {
    if (_selectedSession == null || _compareSession == null) return {};
    return analyticsRepository.compareAverageByClub(
      _selectedSession!,
      _compareSession!,
    );
  }

  /// Carga las sesiones para análisis
  Future<void> loadSessions() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Simular carga de datos (en una aplicación real, esto haría una petición)
      await Future.delayed(const Duration(milliseconds: 800));
      final sessions = practiceRepository.getAllSessions();

      _sessions = sessions;
      if (sessions.isNotEmpty && _selectedSession == null) {
        _selectedSession = sessions.first;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Error al cargar los datos: ${e.toString()}';
      notifyListeners();
    }
  }
}
