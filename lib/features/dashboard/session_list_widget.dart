import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sgs_golf/core/theme/app_theme.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/practice_session.dart';
import 'package:sgs_golf/features/dashboard/providers/dashboard_provider.dart';
import 'package:sgs_golf/shared/utils/animation_utils.dart';
import 'package:sgs_golf/shared/widgets/session_card.dart';

/// Widget que muestra una lista desplazable de sesiones de práctica.
///
/// Permite personalizar si se muestra un máximo de sesiones y el comportamiento
/// al tocar cada sesión o intentar eliminarla. Incluye capacidades de ordenamiento
/// y filtrado de sesiones.
class SessionListWidget extends StatefulWidget {
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

  /// Indica si se debe mostrar los controles de filtrado y ordenamiento
  final bool showFilters;

  /// Constructor para SessionListWidget
  const SessionListWidget({
    super.key,
    required this.sessions,
    this.onSessionTap,
    this.onSessionDelete,
    this.maxSessions,
    this.showFullDetails = false,
    this.emptyMessage = 'No hay sesiones para mostrar',
    this.showFilters = false,
  });

  @override
  State<SessionListWidget> createState() => _SessionListWidgetState();
}

class _SessionListWidgetState extends State<SessionListWidget> {
  bool _showFilterPanel = false;

  @override
  Widget build(BuildContext context) {
    // Si no hay sesiones y no se muestran filtros, mostrar mensaje
    if (widget.sessions.isEmpty && !widget.showFilters) {
      return Center(
        child: AnimationUtils.fadeSlideInAnimation(
          duration: const Duration(milliseconds: 500),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.sports_golf, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                widget.emptyMessage,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Limitar número de sesiones si es necesario
    final displaySessions = widget.maxSessions != null
        ? widget.sessions.take(widget.maxSessions!).toList()
        : widget.sessions;

    // Necesitamos verificar si este widget está dentro de un contenedor con altura definida
    // o si necesita calcular su propia altura
    final bool useShrinkWrap = widget.maxSessions != null;

    final List<Widget> columnChildren = [
      // Controles de ordenamiento y filtrado
      if (widget.showFilters) _buildFilterControls(),

      // Panel expandible de filtros
      if (widget.showFilters && _showFilterPanel) _buildFilterPanel(),

      // Si no hay sesiones después de filtrar
      if (widget.sessions.isEmpty && widget.showFilters)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: Column(
            children: [
              const Icon(Icons.filter_list_off, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'No se encontraron sesiones con los filtros actuales',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Limpiar filtros'),
                onPressed: () {
                  final provider = Provider.of<DashboardProvider>(
                    context,
                    listen: false,
                  );
                  provider.clearFilters();
                },
              ),
            ],
          ),
        )
      else
        // Si tenemos un número máximo de sesiones, usar shrinkWrap en lugar de Expanded
        useShrinkWrap
            ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displaySessions.length,
                itemBuilder: (context, index) {
                  final session = displaySessions[index];
                  return AnimationUtils.animatedListItem(
                    index: index,
                    child: SessionCard(
                      session: session,
                      onTap: widget.onSessionTap != null
                          ? () => widget.onSessionTap!(session)
                          : null,
                      onDelete: widget.onSessionDelete != null
                          ? () => widget.onSessionDelete!(session)
                          : null,
                      showFullDetails: widget.showFullDetails,
                    ),
                  );
                },
              )
            : Flexible(
                child: ListView.builder(
                  itemCount: displaySessions.length,
                  itemBuilder: (context, index) {
                    final session = displaySessions[index];
                    return AnimationUtils.animatedListItem(
                      index: index,
                      child: SessionCard(
                        session: session,
                        onTap: widget.onSessionTap != null
                            ? () => widget.onSessionTap!(session)
                            : null,
                        onDelete: widget.onSessionDelete != null
                            ? () => widget.onSessionDelete!(session)
                            : null,
                        showFullDetails: widget.showFullDetails,
                      ),
                    );
                  },
                ),
              ),
    ];

    return Column(mainAxisSize: MainAxisSize.min, children: columnChildren);
  }

  /// Construye la barra de controles de filtro y ordenamiento
  Widget _buildFilterControls() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextButton.icon(
              icon: const Icon(Icons.sort),
              label: const Text('Ordenar'),
              onPressed: _showSortOptions,
            ),
          ),
          Expanded(
            child: TextButton.icon(
              icon: const Icon(Icons.filter_list),
              label: const Text('Filtrar'),
              onPressed: () {
                setState(() {
                  _showFilterPanel = !_showFilterPanel;
                });
              },
              style: _showFilterPanel
                  ? const ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll(
                        AppColors.zanahoriaIntensa,
                      ),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  /// Muestra el diálogo para seleccionar opciones de ordenamiento
  void _showSortOptions() {
    final provider = Provider.of<DashboardProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Más reciente primero'),
              leading: const Icon(Icons.calendar_today),
              selected: provider.sortOption == SessionSortOption.dateDesc,
              onTap: () {
                provider.setSortOption(SessionSortOption.dateDesc);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Más antigua primero'),
              leading: const Icon(Icons.history),
              selected: provider.sortOption == SessionSortOption.dateAsc,
              onTap: () {
                provider.setSortOption(SessionSortOption.dateAsc);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Mayor duración primero'),
              leading: const Icon(Icons.timelapse),
              selected: provider.sortOption == SessionSortOption.durationDesc,
              onTap: () {
                provider.setSortOption(SessionSortOption.durationDesc);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Menor duración primero'),
              leading: const Icon(Icons.timer_outlined),
              selected: provider.sortOption == SessionSortOption.durationAsc,
              onTap: () {
                provider.setSortOption(SessionSortOption.durationAsc);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Mayor cantidad de tiros'),
              leading: const Icon(Icons.trending_up),
              selected: provider.sortOption == SessionSortOption.shotsDesc,
              onTap: () {
                provider.setSortOption(SessionSortOption.shotsDesc);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Menor cantidad de tiros'),
              leading: const Icon(Icons.trending_down),
              selected: provider.sortOption == SessionSortOption.shotsAsc,
              onTap: () {
                provider.setSortOption(SessionSortOption.shotsAsc);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Construye el panel expandible de filtros
  Widget _buildFilterPanel() {
    final provider = Provider.of<DashboardProvider>(context);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filtrar por:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),

          // Filtro por fecha
          const Text(
            'Rango de fechas:',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _selectDate(isStartDate: true),
                  child: Text(
                    provider.dateFrom != null
                        ? '${provider.dateFrom!.day}/${provider.dateFrom!.month}/${provider.dateFrom!.year}'
                        : 'Fecha inicio',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _selectDate(isStartDate: false),
                  child: Text(
                    provider.dateTo != null
                        ? '${provider.dateTo!.day}/${provider.dateTo!.month}/${provider.dateTo!.year}'
                        : 'Fecha fin',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Filtro por tipo de palo
          const Text(
            'Tipo de palo:',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildClubTypeFilterChip(null, 'Todos', provider),
                _buildClubTypeFilterChip(GolfClubType.pw, 'PW', provider),
                _buildClubTypeFilterChip(GolfClubType.gw, 'GW', provider),
                _buildClubTypeFilterChip(GolfClubType.sw, 'SW', provider),
                _buildClubTypeFilterChip(GolfClubType.lw, 'LW', provider),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Limpiar filtros'),
                onPressed: () => provider.clearFilters(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construye un chip para filtrar por tipo de palo
  Widget _buildClubTypeFilterChip(
    GolfClubType? clubType,
    String label,
    DashboardProvider provider,
  ) {
    final selected =
        clubType == provider.clubTypeFilter ||
        (clubType == null && provider.clubTypeFilter == null);

    Color? chipColor;
    if (clubType != null) {
      switch (clubType) {
        case GolfClubType.pw:
          chipColor = AppColors.zanahoriaIntensa;
          break;
        case GolfClubType.gw:
          chipColor = AppColors.verdeCampo;
          break;
        case GolfClubType.sw:
          chipColor = AppColors.azulProfundo;
          break;
        case GolfClubType.lw:
          chipColor = Colors.purple;
          break;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) =>
            provider.setClubTypeFilter(selected ? null : clubType),
        backgroundColor: chipColor?.withAlpha(50),
        selectedColor: chipColor?.withAlpha(100) ?? AppColors.grisSuave,
        labelStyle: TextStyle(
          color: selected && chipColor != null ? chipColor : null,
          fontWeight: selected ? FontWeight.bold : null,
        ),
      ),
    );
  }

  /// Muestra un selector de fecha
  Future<void> _selectDate({required bool isStartDate}) async {
    final provider = Provider.of<DashboardProvider>(context, listen: false);
    final initialDate = isStartDate
        ? provider.dateFrom ?? DateTime.now()
        : provider.dateTo ?? DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selectedDate != null) {
      if (isStartDate) {
        if (provider.dateTo != null && selectedDate.isAfter(provider.dateTo!)) {
          // Si la fecha de inicio es posterior a la de fin, ajustar la de fin
          provider.setDateRange(selectedDate, selectedDate);
        } else {
          provider.setDateRange(selectedDate, provider.dateTo);
        }
      } else {
        if (provider.dateFrom != null &&
            selectedDate.isBefore(provider.dateFrom!)) {
          // Si la fecha de fin es anterior a la de inicio, ajustar la de inicio
          provider.setDateRange(selectedDate, selectedDate);
        } else {
          provider.setDateRange(provider.dateFrom, selectedDate);
        }
      }
    }
  }
}
