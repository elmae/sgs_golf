import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sgs_golf/core/theme/app_theme.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/features/analysis/providers/analysis_provider.dart';
import 'package:sgs_golf/shared/utils/animation_utils.dart';

class DistanceChartWidget extends StatefulWidget {
  const DistanceChartWidget({super.key});

  @override
  State<DistanceChartWidget> createState() => _DistanceChartWidgetState();
}

class _DistanceChartWidgetState extends State<DistanceChartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final averages = context.watch<AnalysisProvider>().averageByClub;
    return AnimationUtils.fadeSlideInAnimation(
      duration: const Duration(milliseconds: 400),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Promedio de distancia por palo',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: GolfClubType.values.asMap().entries.map((entry) {
                  final index = entry.key;
                  final club = entry.value;
                  final avg = averages[club]?.toStringAsFixed(1) ?? '-';

                  return AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      final Animation<double> barAnimation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(
                                index * 0.2,
                                0.2 + index * 0.2,
                                curve: Curves.easeOut,
                              ),
                            ),
                          );

                      return _buildClubDistanceBar(
                        context,
                        club,
                        avg,
                        barAnimation.value,
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

  Widget _buildClubDistanceBar(
    BuildContext context,
    GolfClubType club,
    String avgDistance,
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

    return Column(
      children: [
        // Nombre del palo
        Text(
          club.name.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 8),

        // Barra animada
        Container(
          width: 50,
          height: 100 * animationValue,
          decoration: BoxDecoration(
            color: color.withAlpha(51), // 0.2 * 255 = 51
            border: Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              '$avgDistance m',
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
