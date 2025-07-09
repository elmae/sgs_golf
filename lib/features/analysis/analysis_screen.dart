import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sgs_golf/features/analysis/charts/consistency_chart_widget.dart';
import 'package:sgs_golf/features/analysis/charts/distance_chart_widget.dart';
import 'package:sgs_golf/features/analysis/providers/analysis_provider.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AnalysisProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Análisis de Sesiones')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton(
              hint: const Text('Selecciona sesión'),
              value: provider.selectedSession,
              items: provider.sessions.map((s) {
                return DropdownMenuItem(
                  value: s,
                  child: Text('${s.date.toLocal()}'),
                );
              }).toList(),
              onChanged: (session) => provider.selectSession(session!),
            ),
            const SizedBox(height: 16),
            const DistanceChartWidget(),
            const SizedBox(height: 16),
            const ConsistencyChartWidget(),
            const SizedBox(height: 16),
            DropdownButton(
              hint: const Text('Comparar con otra sesión'),
              value: provider.compareSession,
              items: provider.sessions
                  .where((s) => s != provider.selectedSession)
                  .map((s) {
                    return DropdownMenuItem(
                      value: s,
                      child: Text('${s.date.toLocal()}'),
                    );
                  })
                  .toList(),
              onChanged: (session) => provider.selectCompareSession(session),
            ),
            if (provider.compareSession != null)
              Card(
                child: Column(
                  children: [
                    const Text(
                      'Comparativa de promedios (actual - comparación)',
                    ),
                    ...provider.comparisonByClub.entries.map(
                      (e) => Text(
                        '${e.key.name.toUpperCase()}: ${e.value.toStringAsFixed(1)} m',
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
