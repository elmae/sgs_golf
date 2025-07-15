import 'package:flutter/material.dart';
import 'package:sgs_golf/core/theme/app_theme.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/practice_session.dart';

/// Widget reutilizable que muestra una tarjeta con la información de una sesión de práctica.
///
/// Este widget puede ser utilizado en múltiples partes de la aplicación donde se necesite
/// mostrar información resumida de una sesión de práctica y sus estadísticas clave.
class SessionCard extends StatelessWidget {
  /// Datos de la sesión a mostrar
  final PracticeSession session;

  /// Función que se ejecuta al presionar la tarjeta
  final VoidCallback? onTap;

  /// Función que se ejecuta al presionar el botón de eliminación
  final VoidCallback? onDelete;

  /// Indica si mostrar los detalles completos de la sesión
  final bool showFullDetails;

  /// Constructor del widget SessionCard
  const SessionCard({
    super.key,
    required this.session,
    this.onTap,
    this.onDelete,
    this.showFullDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    // Calcular hace cuánto tiempo fue la sesión
    final difference = DateTime.now().difference(session.date);
    String timeAgo;

    if (difference.inDays > 0) {
      timeAgo =
          'hace ${difference.inDays} ${difference.inDays == 1 ? 'día' : 'días'}';
    } else if (difference.inHours > 0) {
      timeAgo =
          'hace ${difference.inHours} ${difference.inHours == 1 ? 'hora' : 'horas'}';
    } else {
      timeAgo =
          'hace ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minuto' : 'minutos'}';
    }

    // Calcular cantidad de tiros por tipo de palo
    final Map<GolfClubType, int> shotsByClubType = {};
    for (final shot in session.shots) {
      shotsByClubType[shot.clubType] =
          (shotsByClubType[shot.clubType] ?? 0) + 1;
    }

    // Calcular distancias promedio por tipo de palo
    final Map<GolfClubType, double> avgDistanceByClubType = {};
    for (final clubType in GolfClubType.values) {
      final clubShots = session.shots
          .where((s) => s.clubType == clubType)
          .toList();
      if (clubShots.isNotEmpty) {
        final totalDistance = clubShots.fold(
          0.0,
          (sum, shot) => sum + shot.distance,
        );
        avgDistanceByClubType[clubType] = totalDistance / clubShots.length;
      }
    }

    // Calcular distancia promedio total
    double avgTotalDistance = 0;
    if (session.shots.isNotEmpty) {
      avgTotalDistance =
          session.shots.fold(0.0, (sum, s) => sum + s.distance) /
          session.shots.length;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.azulProfundo.withAlpha(
                  25,
                ), // alpha 25 ~ opacity 0.1
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${session.date.day}/${session.date.month}/${session.date.year}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.azulProfundo,
                    ),
                  ),
                  Text(
                    timeAgo,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            // Cuerpo
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Estadísticas básicas
                  Row(
                    children: [
                      _buildStatContainer(
                        'Duración',
                        '${session.duration.inMinutes} min',
                        Icons.timer,
                        AppColors.verdeCampo,
                      ),
                      const SizedBox(width: 8),
                      _buildStatContainer(
                        'Tiros',
                        '${session.totalShots}',
                        Icons.sports_golf,
                        AppColors.zanahoriaIntensa,
                      ),
                      const SizedBox(width: 8),
                      _buildStatContainer(
                        'Dist. Media',
                        '${avgTotalDistance.toStringAsFixed(1)}m',
                        Icons.straighten,
                        AppColors.azulProfundo,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Desglose por palo
                  if (showFullDetails && shotsByClubType.isNotEmpty) ...[
                    const Text(
                      'Desglose por palo:',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: shotsByClubType.entries.map((entry) {
                        return Chip(
                          backgroundColor: _getClubColor(
                            entry.key,
                          ).withAlpha(51), // alpha 51 ~ opacity 0.2
                          label: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: entry.key
                                      .toString()
                                      .split('.')
                                      .last
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _getClubColor(entry.key),
                                  ),
                                ),
                                const TextSpan(
                                  text: ': ',
                                  style: TextStyle(color: AppColors.grisOscuro),
                                ),
                                TextSpan(
                                  text: '${entry.value} tiros',
                                  style: const TextStyle(
                                    color: AppColors.grisOscuro,
                                  ),
                                ),
                                if (avgDistanceByClubType.containsKey(
                                  entry.key,
                                )) ...[
                                  const TextSpan(
                                    text: ' • ',
                                    style: TextStyle(
                                      color: AppColors.grisOscuro,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        '${avgDistanceByClubType[entry.key]!.toStringAsFixed(1)}m',
                                    style: const TextStyle(
                                      color: AppColors.grisOscuro,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  if (session.summary.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 8),
                    Text(
                      session.summary,
                      maxLines: showFullDetails ? null : 2,
                      overflow: showFullDetails
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],

                  if (onDelete != null) ...[
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: AppColors.rojoAlerta,
                        ),
                        onPressed: onDelete,
                        tooltip: 'Eliminar sesión',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye un contenedor para mostrar una estadística individual
  Widget _buildStatContainer(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withAlpha(25), // alpha 25 ~ opacity 0.1
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 14),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.grisOscuro,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Devuelve un color asociado a cada tipo de palo para visualización
  Color _getClubColor(GolfClubType clubType) {
    switch (clubType) {
      case GolfClubType.pw:
        return AppColors.zanahoriaIntensa;
      case GolfClubType.gw:
        return AppColors.verdeCampo;
      case GolfClubType.sw:
        return AppColors.azulProfundo;
      case GolfClubType.lw:
        return Colors.purple;
    }
  }
}
