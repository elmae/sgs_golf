import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sgs_golf/core/theme/app_theme.dart';
import 'package:sgs_golf/features/analysis/charts/consistency_chart_widget.dart';
import 'package:sgs_golf/features/analysis/charts/distance_chart_widget.dart';
import 'package:sgs_golf/features/analysis/providers/analysis_provider.dart';
import 'package:sgs_golf/shared/widgets/animated_date_range_picker.dart';
import 'package:sgs_golf/shared/widgets/animated_filter_chip.dart';
import 'package:sgs_golf/shared/widgets/app_empty_state_widget.dart';
import 'package:sgs_golf/shared/widgets/app_loading_widget.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  String _activeFilter = 'distance'; // Filtro inicial

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();

    // Cargar datos al inicializar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AnalysisProvider>(context, listen: false).loadSessions();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            AnimatedFilterChip(
              label: 'Distancia',
              icon: Icons.straighten,
              color: AppColors.verdeCampo,
              selected: _activeFilter == 'distance',
              onTap: () => setState(() => _activeFilter = 'distance'),
            ),
            const SizedBox(width: 8),
            AnimatedFilterChip(
              label: 'Consistencia',
              icon: Icons.timeline,
              color: AppColors.azulProfundo,
              selected: _activeFilter == 'consistency',
              onTap: () => setState(() => _activeFilter = 'consistency'),
            ),
            const SizedBox(width: 8),
            AnimatedFilterChip(
              label: 'Progresión',
              icon: Icons.trending_up,
              color: AppColors.zanahoriaIntensa,
              selected: _activeFilter == 'progression',
              onTap: () => setState(() => _activeFilter = 'progression'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Hero(
              tag: 'hero-icon-Análisis',
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.bar_chart, size: 24),
              ),
            ),
            const SizedBox(width: 8),
            const Hero(
              tag: 'hero-text-Análisis',
              child: Material(
                color: Colors.transparent,
                child: Text('Análisis de Sesiones'),
              ),
            ),
          ],
        ),
      ),
      body: Consumer<AnalysisProvider>(
        builder: (context, provider, child) {
          // Mostrar indicador de carga
          if (provider.isLoading) {
            return const AppLoadingWidget(
              message: 'Cargando datos de análisis...',
              showBackground: true,
            );
          }

          // Mostrar mensaje de error
          if (provider.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.rojoAlerta,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      provider.error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.rojoAlerta),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => provider.loadSessions(),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Mostrar estado vacío
          if (provider.sessions.isEmpty) {
            return AppEmptyStateWidget(
              icon: Icons.analytics,
              title: 'Sin datos para análisis',
              message:
                  'Aún no hay sesiones de práctica registradas para analizar',
              buttonText: 'Crear sesión de práctica',
              onButtonPressed: () =>
                  Navigator.of(context).pushNamed('/practice'),
            );
          }

          // Mostrar contenido principal
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Filtros animados
                _buildFilterSection(),

                // Selector de fechas animado
                AnimatedDateRangePicker(
                  title: 'Rango de fechas',
                  color: AppColors.azulProfundo,
                  selectedRange: provider.selectedSession != null
                      ? DateTimeRange(
                          start: provider.selectedSession!.date,
                          end: provider.selectedSession!.date,
                        )
                      : null,
                  onRangeSelected: (range) {
                    // Aquí se implementaría la lógica para filtrar por rango
                  },
                ),

                const SizedBox(height: 16),

                // Selector de sesión
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selecciona sesión',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButton<dynamic>(
                          isExpanded: true,
                          hint: const Text('Selecciona sesión para analizar'),
                          value: provider.selectedSession,
                          items: provider.sessions.map((s) {
                            return DropdownMenuItem(
                              value: s,
                              child: Text(
                                '${s.date.day}/${s.date.month}/${s.date.year} - ${s.totalShots} tiros',
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (session) =>
                              provider.selectSession(session!),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Gráficos con animación
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _activeFilter == 'distance'
                      ? const DistanceChartWidget(key: ValueKey('distance'))
                      : const ConsistencyChartWidget(
                          key: ValueKey('consistency'),
                        ),
                ),

                const SizedBox(height: 16),

                // Sección de comparación
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Comparar con otra sesión',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButton<dynamic>(
                          isExpanded: true,
                          hint: const Text('Selecciona sesión para comparar'),
                          value: provider.compareSession,
                          items: provider.sessions
                              .where((s) => s != provider.selectedSession)
                              .map((s) {
                                return DropdownMenuItem(
                                  value: s,
                                  child: Text(
                                    '${s.date.day}/${s.date.month}/${s.date.year} - ${s.totalShots} tiros',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              })
                              .toList(),
                          onChanged: (session) =>
                              provider.selectCompareSession(session),
                        ),

                        if (provider.compareSession != null)
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.azulProfundo.withAlpha(
                                26,
                              ), // 0.1 * 255 = 25.5 ≈ 26
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.azulProfundo.withAlpha(
                                  77,
                                ), // 0.3 * 255 = 76.5 ≈ 77
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.compare_arrows,
                                  size: 16,
                                  color: AppColors.azulProfundo,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Comparando con: ${provider.compareSession!.date.day}/${provider.compareSession!.date.month}/${provider.compareSession!.date.year}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.azulProfundo,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, size: 16),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () =>
                                      provider.selectCompareSession(null),
                                  color: AppColors.azulProfundo,
                                ),
                              ],
                            ),
                          ),

                        if (provider.compareSession != null)
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.withAlpha(
                                26,
                              ), // 0.1 * 255 = 25.5 ≈ 26
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Comparativa de promedios (actual - comparación)',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                ...provider.comparisonByClub.entries.map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 2.0,
                                    ),
                                    child: Text(
                                      '${e.key.name.toUpperCase()}: ${e.value.toStringAsFixed(1)} m',
                                      style: TextStyle(
                                        color: e.value > 0
                                            ? AppColors.verdeCampo
                                            : e.value < 0
                                            ? AppColors.rojoAlerta
                                            : Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
