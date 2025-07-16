import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sgs_golf/core/navigation/app_router.dart';
import 'package:sgs_golf/core/theme/app_theme.dart';
import 'package:sgs_golf/features/dashboard/providers/dashboard_provider.dart';
import 'package:sgs_golf/features/dashboard/session_list_widget.dart';
import 'package:sgs_golf/features/demo/routes.dart';
import 'package:sgs_golf/shared/widgets/app_empty_state_widget.dart';
import 'package:sgs_golf/shared/widgets/app_loading_widget.dart';

/// Pantalla principal que sirve como hub central de la aplicación
///
/// Esta pantalla muestra:
/// - Un resumen de estadísticas recientes
/// - Accesos rápidos a las funcionalidades principales
/// - Lista de sesiones de práctica recientes
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar datos al inicializar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardProvider>(context, listen: false).loadSessions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SGS Golf'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<DashboardProvider>(
                context,
                listen: false,
              ).refreshData();
            },
            tooltip: 'Actualizar',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navegación a configuración (futuro)
            },
            tooltip: 'Configuración',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<DashboardProvider>(
            context,
            listen: false,
          ).refreshData();
        },
        child: Consumer<DashboardProvider>(
          builder: (context, dashboardProvider, child) {
            if (dashboardProvider.isLoading) {
              return const AppLoadingWidget(
                message: 'Cargando sesiones...',
                showBackground: true,
              );
            }

            if (dashboardProvider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: AppColors.rojoAlerta,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      dashboardProvider.error!,
                      style: const TextStyle(color: AppColors.rojoAlerta),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => dashboardProvider.refreshData(),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }

            if (dashboardProvider.sessions.isEmpty) {
              return AppEmptyStateWidget(
                icon: Icons.sports_golf,
                title: 'No hay sesiones',
                message: 'Aún no has registrado ninguna sesión de práctica',
                buttonText: 'Crear sesión',
                onButtonPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.practice),
              );
            }

            return _buildDashboardContent(dashboardProvider);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.practice);
        },
        label: const Text('Nueva Práctica'),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.verdeCampo,
      ),
    );
  }

  Widget _buildDashboardContent(DashboardProvider provider) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildStatsCards(provider),
        const SizedBox(height: 16),
        _buildQuickAccessButtons(),
        const SizedBox(height: 24),
        _buildRecentSessionsSection(provider),
      ],
    );
  }

  Widget _buildStatsCards(DashboardProvider provider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estadísticas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    Icons.event,
                    provider.totalSessions.toString(),
                    'Sesiones',
                    AppColors.azulProfundo,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    Icons.sports_golf,
                    provider.totalShots.toString(),
                    'Tiros',
                    AppColors.zanahoriaIntensa,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    Icons.trending_up,
                    provider.averageShotsPerSession.toStringAsFixed(1),
                    'Promedio',
                    AppColors.verdeCampo,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildQuickAccessButtons() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildQuickAccessButton(
              'Práctica',
              Icons.sports_golf,
              AppColors.verdeCampo,
              () => Navigator.of(context).pushNamed(AppRoutes.practice),
            ),
            _buildQuickAccessButton(
              'Análisis',
              Icons.bar_chart,
              AppColors.azulProfundo,
              () => Navigator.of(context).pushNamed(AppRoutes.analysis),
            ),
            _buildQuickAccessButton(
              'Exportar',
              Icons.file_download,
              AppColors.zanahoriaIntensa,
              () => Navigator.of(context).pushNamed(AppRoutes.export),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildQuickAccessButton(
              'Demo UI',
              Icons.palette,
              AppColors.grisOscuro,
              () => Navigator.of(context).pushNamed(DemoRoutes.componentsDemo),
            ),
            _buildQuickAccessButton(
              'Componentes',
              Icons.design_services,
              AppColors.azulProfundo,
              () =>
                  Navigator.of(context).pushNamed(DemoRoutes.uiComponentsDemo),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAccessButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Hero(
              tag: 'hero-icon-$label',
              flightShuttleBuilder:
                  (
                    flightContext,
                    animation,
                    flightDirection,
                    fromHeroContext,
                    toHeroContext,
                  ) {
                    // Personalizar la animación del Hero
                    return AnimatedBuilder(
                      animation: animation,
                      child: Icon(icon, color: color, size: 28),
                      builder: (context, child) {
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: color.withAlpha(
                              25 + (animation.value * 50).toInt(),
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: child,
                        );
                      },
                    );
                  },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
            ),
            const SizedBox(height: 8),
            Hero(
              tag: 'hero-text-$label',
              child: Material(
                color: Colors.transparent,
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSessionsSection(DashboardProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Sesiones recientes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                // Ver todas las sesiones (para futuro desarrollo)
              },
              child: const Text('Ver todas'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SessionListWidget(
          sessions: provider.sessions,
          maxSessions: 5, // Mostrar solo las 5 más recientes
          showFilters: true, // Activar opciones de filtrado y ordenamiento
          onSessionTap: (session) {
            // En futuras implementaciones, navegar a detalle de sesión
          },
          onSessionDelete: (session) {
            // Confirmar antes de eliminar
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('¿Eliminar sesión?'),
                content: const Text('Esta acción no se puede deshacer'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Usar el key de Hive para eliminar
                      final key = provider.sessions.indexOf(session);
                      if (key >= 0) {
                        provider.deleteSession(key);
                      }
                    },
                    child: const Text('Eliminar'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
