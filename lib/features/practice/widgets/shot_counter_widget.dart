import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/features/practice/providers/practice_provider.dart';
import 'package:sgs_golf/features/practice/widgets/club_selector_widget.dart';

/// Widget que muestra los contadores de tiros por cada tipo de palo
/// durante una sesión de práctica.
///
/// Se actualiza en tiempo real a medida que se registran nuevos tiros.
class ShotCounterWidget extends StatelessWidget {
  /// Constructor del widget
  const ShotCounterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PracticeProvider>(
      builder: (context, provider, _) {
        // Si no hay sesión activa, mostrar mensaje
        if (provider.activeSession == null) {
          return const Center(child: Text('No hay sesión activa'));
        }

        // Si hay sesión pero no hay tiros, mostrar mensaje
        if (provider.activeSession!.shots.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Aún no has registrado tiros',
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          );
        }

        return _buildCounterGrid(context, provider);
      },
    );
  }

  Widget _buildCounterGrid(BuildContext context, PracticeProvider provider) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tiros por palo', style: theme.textTheme.titleMedium),
                Text(
                  'Total: ${provider.activeSession!.totalShots}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              childAspectRatio: 2.5,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: GolfClubType.values.map((clubType) {
                final count = provider.countByClub(clubType);
                final percentage = provider.activeSession!.totalShots > 0
                    ? (count / provider.activeSession!.totalShots * 100).toInt()
                    : 0;

                return _buildClubCounter(
                  context: context,
                  clubType: clubType,
                  count: count,
                  percentage: percentage,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClubCounter({
    required BuildContext context,
    required GolfClubType clubType,
    required int count,
    required int percentage,
  }) {
    final theme = Theme.of(context);
    final clubName = ClubSelectorWidget.clubNames[clubType] ?? clubType.name;
    final clubIcon =
        ClubSelectorWidget.clubIcons[clubType] ?? Icons.golf_course;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: theme.colorScheme.surfaceContainerHighest,
      ),
      child: Row(
        children: [
          Icon(clubIcon, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  clubName,
                  style: theme.textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$count tiros',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('$percentage%', style: theme.textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
