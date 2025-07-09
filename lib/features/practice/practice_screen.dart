import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/shot.dart';
import 'package:sgs_golf/features/practice/club_selector_widget.dart';
import 'package:sgs_golf/features/practice/distance_input_widget.dart';
import 'package:sgs_golf/features/practice/providers/practice_provider.dart';
import 'package:sgs_golf/features/practice/shot_counter_widget.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  GolfClubType _selectedClub = GolfClubType.pw;
  double? _distance;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PracticeProvider>(context);
    final session = provider.activeSession;
    final counts = <GolfClubType, int>{
      for (var club in GolfClubType.values) club: provider.countByClub(club),
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Sesión de Práctica')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClubSelectorWidget(
              selectedClub: _selectedClub,
              onClubSelected: (club) => setState(() => _selectedClub = club),
            ),
            const SizedBox(height: 16),
            DistanceInputWidget(
              value: _distance,
              onChanged: (val) => setState(() => _distance = val),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _distance != null
                  ? () {
                      provider.addShot(
                        Shot(
                          clubType: _selectedClub,
                          distance: _distance!,
                          timestamp: DateTime.now(),
                        ),
                      );
                      setState(() => _distance = null);
                    }
                  : null,
              child: const Text('Añadir Tiro'),
            ),
            const SizedBox(height: 24),
            ShotCounterWidget(counts: counts),
            const Spacer(),
            ElevatedButton(
              onPressed: session != null ? provider.saveSession : null,
              child: const Text('Guardar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
