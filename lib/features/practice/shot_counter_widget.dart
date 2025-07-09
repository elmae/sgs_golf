import 'package:flutter/material.dart';
import 'package:sgs_golf/data/models/golf_club.dart';

class ShotCounterWidget extends StatelessWidget {
  final Map<GolfClubType, int> counts;

  const ShotCounterWidget({super.key, required this.counts});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: GolfClubType.values.map((club) {
        return Column(
          children: [
            Text(club.name.toUpperCase()),
            CircleAvatar(child: Text('${counts[club] ?? 0}')),
          ],
        );
      }).toList(),
    );
  }
}
