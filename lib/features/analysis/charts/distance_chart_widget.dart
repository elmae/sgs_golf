import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/features/analysis/providers/analysis_provider.dart';

class DistanceChartWidget extends StatelessWidget {
  const DistanceChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final averages = context.watch<AnalysisProvider>().averageByClub;
    return Card(
      child: Column(
        children: [
          const Text('Promedio de distancia por palo'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: GolfClubType.values.map((club) {
              final avg = averages[club]?.toStringAsFixed(1) ?? '-';
              return Column(
                children: [Text(club.name.toUpperCase()), Text('$avg m')],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
