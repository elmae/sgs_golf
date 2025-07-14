import 'package:flutter/material.dart';
import 'package:sgs_golf/core/theme/app_theme.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/practice_session.dart';

/// Widget reutilizable que muestra una tarjeta con la información de una sesión de práctica.
///
/// Este widget puede ser utilizado en múltiples partes de la aplicación donde se necesite
/// mostrar información resumida de una sesión de práctica.
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

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${session.date.day}/${session.date.month}/${session.date.year}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    timeAgo,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Duración: ${session.duration.inMinutes} minutos'),
              const SizedBox(height: 4),
              Text('Tiros: ${session.totalShots}'),
              if (showFullDetails && shotsByClubType.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text(
                  'Desglose por palo:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  children: shotsByClubType.entries.map((entry) {
                    return Chip(
                      backgroundColor: _getClubColor(
                        entry.key,
                      ).withAlpha(51), // alpha 51 ~ opacity 0.2
                      label: Text(
                        '${entry.key.toString().split('.').last.toUpperCase()}: ${entry.value}',
                        style: TextStyle(color: _getClubColor(entry.key)),
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: const EdgeInsets.all(0),
                    );
                  }).toList(),
                ),
              ],
              if (session.summary.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  session.summary,
                  maxLines: showFullDetails ? null : 2,
                  overflow: showFullDetails
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
              if (onDelete != null) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: AppColors.rojoAlerta),
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
