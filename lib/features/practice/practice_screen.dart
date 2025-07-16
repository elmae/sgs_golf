import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/shot.dart';
import 'package:sgs_golf/features/practice/club_selector_widget.dart';
import 'package:sgs_golf/features/practice/distance_input_widget.dart';
import 'package:sgs_golf/features/practice/providers/practice_provider.dart';
import 'package:sgs_golf/features/practice/shot_counter_widget.dart';
import 'package:sgs_golf/features/practice/statistics_widget.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  GolfClubType _selectedClub = GolfClubType.pw;
  double? _distance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _distanceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicializa una sesión si no hay una activa
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<PracticeProvider>(context, listen: false);
      if (provider.activeSession == null) {
        provider.startSession(DateTime.now());
      }
    });
  }

  @override
  void dispose() {
    _distanceController.dispose();
    super.dispose();
  }

  void _addShot(PracticeProvider provider) {
    if (_distance != null && _distance! > 0) {
      provider.addShot(
        Shot(
          clubType: _selectedClub,
          distance: _distance!,
          timestamp: DateTime.now(),
        ),
      );

      // Reset del campo de distancia y muestra feedback
      setState(() {
        _distanceController.clear();
        _distance = null;
      });

      // Muestra un feedback visual
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tiro añadido: ${_selectedClub.name.toUpperCase()} a $_distance metros',
          ),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PracticeProvider>(context);
    final session = provider.activeSession;
    final counts = <GolfClubType, int>{
      for (var club in GolfClubType.values) club: provider.countByClub(club),
    };

    // Estadísticas para el palo seleccionado
    final selectedClubAvgDistance = provider.averageDistanceByClub(
      _selectedClub,
    );
    final selectedClubCount = provider.countByClub(_selectedClub);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Hero(
              tag: 'hero-icon-Práctica',
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.sports_golf, size: 24),
              ),
            ),
            const SizedBox(width: 8),
            const Hero(
              tag: 'hero-text-Práctica',
              child: Material(
                color: Colors.transparent,
                child: Text('Sesión de Práctica'),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: session != null
                ? () async {
                    await provider.saveSession();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sesión guardada correctamente'),
                        ),
                      );
                    }
                  }
                : null,
            tooltip: 'Guardar Sesión',
          ),
        ],
      ),
      body: session == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Sección superior - Contador de tiros
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Text(
                                'Resumen de tiros',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ShotCounterWidget(counts: counts),
                              const SizedBox(height: 8),
                              Text(
                                'Total: ${session.totalShots} tiros',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Sección media - Selección de palo
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Selecciona el palo',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ClubSelectorWidget(
                                selectedClub: _selectedClub,
                                onClubSelected: (club) =>
                                    setState(() => _selectedClub = club),
                              ),
                              if (selectedClubCount > 0) ...[
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Promedio ${_selectedClub.name.toUpperCase()}:',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${selectedClubAvgDistance.toStringAsFixed(1)} m',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Sección inferior - Input de distancia
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Registra el tiro',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              DistanceInputWidget(
                                value: _distance,
                                onChanged: (val) =>
                                    setState(() => _distance = val),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: _distance != null && _distance! > 0
                                    ? () => _addShot(provider)
                                    : null,
                                icon: const Icon(Icons.add),
                                label: const Text('AÑADIR TIRO'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Sección de estadísticas en tiempo real
                      const SizedBox(height: 24),
                      StatisticsWidget(statistics: provider.statistics),

                      // Botón de finalizar sesión
                      const SizedBox(height: 24),
                      OutlinedButton.icon(
                        onPressed: () async {
                          await provider.saveSession();
                          if (context.mounted) {
                            provider.endSession();
                            Navigator.pop(context);
                          }
                        },
                        icon: const Icon(Icons.check_circle),
                        label: const Text('FINALIZAR SESIÓN'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
