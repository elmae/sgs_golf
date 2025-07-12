import 'package:flutter/material.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/session_statistics.dart';
import 'package:sgs_golf/data/models/session_statistics_ext.dart';

/// Widget que muestra estadísticas en tiempo real de la sesión de práctica.
class StatisticsWidget extends StatelessWidget {
  /// Las estadísticas a mostrar
  final SessionStatistics statistics;

  const StatisticsWidget({super.key, required this.statistics});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estadísticas en tiempo real',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Sección general
        _buildGeneralStatsSection(theme),
        const SizedBox(height: 20),

        // Sección por palo
        _buildClubStatsSection(theme),
      ],
    );
  }

  Widget _buildGeneralStatsSection(ThemeData theme) {
    // Obtenemos el palo más usado para mostrar en las estadísticas
    final mostUsedClub = statistics.getMostUsedClubType();

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'General',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Fila 1: Tiros totales y Distancia total
            Row(
              children: [
                Expanded(
                  child: _buildStatTile(
                    theme,
                    'Tiros totales',
                    '${statistics.totalShots}',
                    Icons.sports_golf,
                  ),
                ),
                Expanded(
                  child: _buildStatTile(
                    theme,
                    'Distancia total',
                    '${statistics.totalDistance.toStringAsFixed(1)} m',
                    Icons.straighten,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Fila 2: Promedio de distancia y Duración
            Row(
              children: [
                Expanded(
                  child: _buildStatTile(
                    theme,
                    'Distancia promedio',
                    '${statistics.averageDistance.toStringAsFixed(1)} m',
                    Icons.speed,
                  ),
                ),
                Expanded(
                  child: _buildStatTile(
                    theme,
                    'Duración',
                    statistics.formattedDuration,
                    Icons.timer,
                  ),
                ),
              ],
            ),

            // Fila 3: Consistencia general y Palo más usado (si hay datos)
            if (statistics.totalShots > 0) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatTile(
                      theme,
                      'Consistencia',
                      '${statistics.overallConsistency.toStringAsFixed(1)}%',
                      Icons.analytics,
                    ),
                  ),
                  Expanded(
                    child: _buildStatTile(
                      theme,
                      'Palo más usado',
                      mostUsedClub != null
                          ? mostUsedClub.name.toUpperCase()
                          : '-',
                      Icons.star,
                    ),
                  ),
                ],
              ),
            ],

            // Fila 4: Tasa de tiros por minuto y Mejor palo
            if (statistics.shotsPerMinute != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatTile(
                      theme,
                      'Tiros por minuto',
                      statistics.shotsPerMinute!.toStringAsFixed(1),
                      Icons.update,
                    ),
                  ),
                  Expanded(
                    child: _buildStatTile(
                      theme,
                      'Palo más preciso',
                      statistics.getLongestClubType() != null
                          ? statistics.getLongestClubType()!.name.toUpperCase()
                          : '-',
                      Icons.precision_manufacturing,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildClubStatsSection(ThemeData theme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estadísticas por palo',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Tabla de estadísticas por palo
            _buildClubStatsTable(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildClubStatsTable(ThemeData theme) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.2), // Palo
        1: FlexColumnWidth(0.8), // Tiros
        2: FlexColumnWidth(1.5), // Dist. Prom.
        3: FlexColumnWidth(1.2), // Consistencia
      },
      border: TableBorder.all(
        color: theme.dividerColor.withAlpha(77), // 0.3 * 255 = 77
        width: 0.5,
      ),
      children: [
        // Encabezado
        TableRow(
          decoration: BoxDecoration(
            color: theme.primaryColor.withAlpha(26),
          ), // 0.1 * 255 = 26
          children: [
            _buildTableCell('Palo', theme, isHeader: true),
            _buildTableCell('Tiros', theme, isHeader: true),
            _buildTableCell('Dist. Prom.', theme, isHeader: true),
            _buildTableCell('Consist.', theme, isHeader: true),
          ],
        ),

        // Filas con datos de cada palo
        for (final club in GolfClubType.values)
          TableRow(
            decoration: BoxDecoration(
              // Destacar el palo más usado
              color:
                  club == statistics.getMostUsedClubType() &&
                      statistics.hasShotsForClub(club)
                  ? theme.primaryColor.withAlpha(13) // 0.05 * 255 = 13
                  : null,
            ),
            children: [
              _buildTableCell(club.name.toUpperCase(), theme),
              _buildTableCell('${statistics.shotCounts[club]}', theme),
              _buildTableCell(
                statistics.hasShotsForClub(club)
                    ? '${statistics.averageDistanceByClub[club]!.toStringAsFixed(1)} m'
                    : '-',
                theme,
              ),
              _buildTableCell(
                statistics.hasShotsForClub(club)
                    ? '${statistics.consistencyByClub[club]!.toStringAsFixed(0)}%'
                    : '-',
                theme,
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildTableCell(
    String text,
    ThemeData theme, {
    bool isHeader = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: isHeader
            ? theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)
            : theme.textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildStatTile(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: theme.primaryColor, size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
