import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sgs_golf/core/theme/app_theme.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/features/analysis/providers/analysis_provider.dart';
import 'package:sgs_golf/shared/utils/animation_utils.dart';

class ConsistencyChartWidget extends StatefulWidget {
  const ConsistencyChartWidget({super.key});

  @override
  State<ConsistencyChartWidget> createState() => _ConsistencyChartWidgetState();
}

class _ConsistencyChartWidgetState extends State<ConsistencyChartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Retrasar un poco la animación de consistencia para que comience después del gráfico de distancia
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          _animationController.forward();
        }
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final consistencies = context.watch<AnalysisProvider>().consistencyByClub;
    return AnimationUtils.fadeSlideInAnimation(
      duration: const Duration(milliseconds: 500),
      offset: 30.0,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Consistencia (desviación estándar) por palo',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: GolfClubType.values.asMap().entries.map((entry) {
                  final index = entry.key;
                  final club = entry.value;
                  final std = consistencies[club]?.toStringAsFixed(1) ?? '-';

                  return AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      final Animation<double> animation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(
                                0.1 + index * 0.2,
                                0.3 + index * 0.2,
                                curve: Curves.elasticOut,
                              ),
                            ),
                          );

                      return _buildConsistencyIndicator(
                        context,
                        club,
                        std,
                        animation.value,
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConsistencyIndicator(
    BuildContext context,
    GolfClubType club,
    String consistencyValue,
    double animationValue,
  ) {
    // Determinar el color según el tipo de palo
    Color getClubColor() {
      switch (club) {
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

    final color = getClubColor();
    final radius = 30.0 * animationValue; // Radio del círculo animado

    return Column(
      children: [
        // Nombre del palo
        Text(
          club.name.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 8),

        // Indicador circular con animación
        Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withAlpha(51), // 0.2 * 255 = 51
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              consistencyValue,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text('metros', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
