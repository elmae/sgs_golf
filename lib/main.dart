import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sgs_golf/app.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/practice_session.dart';
import 'package:sgs_golf/data/models/shot.dart';
import 'package:sgs_golf/data/models/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(GolfClubAdapter());
  Hive.registerAdapter(GolfClubTypeAdapter());
  Hive.registerAdapter(ShotAdapter());
  Hive.registerAdapter(PracticeSessionAdapter());
  Hive.registerAdapter(DurationAdapter());

  await Hive.openBox<User>('users');
  await Hive.openBox<GolfClub>('golfClubs');
  await Hive.openBox<Shot>('shots');
  await Hive.openBox<PracticeSession>('practiceSessions');

  runApp(const SGSGolfApp());
}

// El widget MyApp ya no es necesario, ahora usamos SGSGolfApp desde app.dart
