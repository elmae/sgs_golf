import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/features/analysis/providers/analysis_provider.dart';

class ConsistencyChartWidget extends StatelessWidget {
  const ConsistencyChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final consistencies = context.watch<AnalysisProvider>().consistencyByClub;
    return Card(
      child: Column(
        children: [
          const Text('Consistencia (desviación estándar) por palo'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: GolfClubType.values.map((club) {
              final std = consistencies[club]?.toStringAsFixed(1) ?? '-';
              return Column(
                children: [Text(club.name.toUpperCase()), Text('$std m')],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
