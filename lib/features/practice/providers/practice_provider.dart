
import 'package:flutter/material.dart';
import 'package:sgs_golf/data/models/practice_session.dart';
import 'package:sgs_golf/data/models/practice_session_ext.dart';
import 'package:sgs_golf/data/models/shot.dart';
import 'package:sgs_golf/data/repositories/practice_repository.dart';


import 'package:sgs_golf/data/models/golf_club.dart';

class PracticeProvider extends ChangeNotifier {
  /// Club seleccionado para el siguiente disparo en la sesión activa.
  GolfClubType? _nextClubType;
  GolfClubType? get nextClubType => _nextClubType;

  /// Permite seleccionar el club para el siguiente disparo.
  void setNextClubType(GolfClubType clubType) {
    _nextClubType = clubType;
    notifyListeners();
  }
  final PracticeRepository repository;
  PracticeSession? _activeSession;
  int? _activeSessionKey;

  PracticeProvider(this.repository);

  PracticeSession? get activeSession => _activeSession;
  int? get activeSessionKey => _activeSessionKey;

  void startSession(DateTime date) {
    _activeSession = PracticeSession(
      date: date,
      duration: Duration.zero,
      shots: const [],
      summary: '',
    );
    _activeSessionKey = null;
    notifyListeners();
  }

  Future<void> saveSession() async {
    if (_activeSession != null) {
      if (_activeSessionKey == null) {
        _activeSessionKey = await repository.createSession(_activeSession!);
      } else {
        await repository.updateSession(_activeSessionKey!, _activeSession!);
      }
      notifyListeners();
    }
  }

  void addShot(Shot shot) {
    if (_activeSession != null) {
      _activeSession = _activeSession!.copyWith(
        shots: List<Shot>.from(_activeSession!.shots)..add(shot),
      );
      notifyListeners();
    }
  }

  void endSession() {
    _activeSession = null;
    _activeSessionKey = null;
    notifyListeners();
  }

  // Estadísticas en tiempo real
  int countByClub(clubType) => _activeSession?.countByClub(clubType) ?? 0;
  double averageDistanceByClub(clubType) =>
      _activeSession?.averageDistanceByClub(clubType) ?? 0;
}
