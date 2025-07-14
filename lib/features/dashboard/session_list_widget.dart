import 'package:flutter/material.dart';
import 'package:sgs_golf/data/models/practice_session.dart';
import 'package:sgs_golf/shared/widgets/session_card.dart';

/// Widget que muestra una lista desplazable de sesiones de práctica.
///
/// Permite personalizar si se muestra un máximo de sesiones y el comportamiento
/// al tocar cada sesión o intentar eliminarla.
class SessionListWidget extends StatelessWidget {
  /// Lista de sesiones a mostrar
  final List<PracticeSession> sessions;

  /// Función callback que se llama al presionar una sesión
  final Function(PracticeSession)? onSessionTap;

  /// Función callback que se llama al intentar eliminar una sesión
  final Function(PracticeSession)? onSessionDelete;

  /// Número máximo de sesiones a mostrar (null para mostrar todas)
  final int? maxSessions;

  /// Indica si mostrar los detalles completos de cada sesión
  final bool showFullDetails;

  /// Mensaje a mostrar cuando no hay sesiones
  final String emptyMessage;

  /// Constructor para SessionListWidget
  const SessionListWidget({
    super.key,
    required this.sessions,
    this.onSessionTap,
    this.onSessionDelete,
    this.maxSessions,
    this.showFullDetails = false,
    this.emptyMessage = 'No hay sesiones para mostrar',
  });

  @override
  Widget build(BuildContext context) {
    // Si no hay sesiones, mostrar mensaje
    if (sessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sports_golf, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Limitar número de sesiones si es necesario
    final displaySessions = maxSessions != null
        ? sessions.take(maxSessions!).toList()
        : sessions;

    return ListView.builder(
      shrinkWrap: true,
      physics: maxSessions != null
          ? const NeverScrollableScrollPhysics()
          : null,
      itemCount: displaySessions.length,
      itemBuilder: (context, index) {
        final session = displaySessions[index];
        return SessionCard(
          session: session,
          onTap: onSessionTap != null ? () => onSessionTap!(session) : null,
          onDelete: onSessionDelete != null
              ? () => onSessionDelete!(session)
              : null,
          showFullDetails: showFullDetails,
        );
      },
    );
  }
}
