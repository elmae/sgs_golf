import 'package:hive/hive.dart';
import 'package:sgs_golf/data/models/practice_session.dart';
import 'package:sgs_golf/data/models/practice_session_ext.dart';
import 'package:sgs_golf/data/models/shot.dart';

class PracticeRepository {
  final Box<PracticeSession> _sessionBox;

  PracticeRepository(this._sessionBox);

  // CRUD: Create a new session
  Future<int> createSession(PracticeSession session) async {
    // HiveObject has a key property, but PracticeSession does not have an id field.
    // We'll use auto-increment keys from Hive.
    return await _sessionBox.add(session);
  }

  // Read all sessions
  List<PracticeSession> getAllSessions() {
    return _sessionBox.values.toList();
  }

  // Update a session
  Future<void> updateSession(int key, PracticeSession session) async {
    await _sessionBox.put(key, session);
  }

  // Delete a session
  Future<void> deleteSession(int key) async {
    await _sessionBox.delete(key);
  }

  // Add a shot to an active session
  Future<void> addShotToSession(int key, Shot shot) async {
    final session = _sessionBox.get(key);
    if (session != null) {
      final updatedSession = session.copyWith(
        shots: List<Shot>.from(session.shots)..add(shot),
      );
      await _sessionBox.put(key, updatedSession);
    }
  }

  // Get session by ID
  PracticeSession? getSessionByKey(int key) {
    return _sessionBox.get(key);
  }
}
