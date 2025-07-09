import 'package:flutter/material.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/practice_session.dart';
import 'package:sgs_golf/data/repositories/analytics_repository.dart';

class AnalysisProvider extends ChangeNotifier {
  final AnalyticsRepository analyticsRepository;
  List<PracticeSession> _sessions = [];
  PracticeSession? _selectedSession;
  PracticeSession? _compareSession;

  AnalysisProvider(this.analyticsRepository);

  List<PracticeSession> get sessions => _sessions;
  PracticeSession? get selectedSession => _selectedSession;
  PracticeSession? get compareSession => _compareSession;

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
}
