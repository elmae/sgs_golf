import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/practice_session.dart';
import 'package:sgs_golf/data/models/shot.dart';
import 'package:sgs_golf/data/models/user.dart';
import 'package:sgs_golf/features/practice/distance_input_widget.dart';

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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SGS Golf',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Prueba DistanceInputWidget')),
        body: Center(
          child: DistanceInputWidget(
            value: 50,
            onChanged: (v) {
              // Puedes mostrar un snackbar o procesar el valor
              // Ejemplo: mostrar un snackbar con el valor
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(content: Text('Distancia ingresada: $v')),
              // );
            },
          ),
        ),
      ),
    );
  }
}
