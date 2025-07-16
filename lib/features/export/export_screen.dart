import 'package:flutter/material.dart';
import 'package:sgs_golf/shared/utils/animation_utils.dart';

/// Pantalla para exportación de datos y reportes
class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Hero(
              tag: 'hero-icon-Exportar',
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.file_download, size: 24),
              ),
            ),
            const SizedBox(width: 8),
            const Hero(
              tag: 'hero-text-Exportar',
              child: Material(
                color: Colors.transparent,
                child: Text('Exportar datos'),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimationUtils.fadeSlideInAnimation(
              child: const Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Exportar sesiones',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Selecciona el formato de exportación y el rango de fechas para generar un informe de tus sesiones de práctica.',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            AnimationUtils.fadeSlideInAnimation(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Formato',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      AnimationUtils.fadeSlideInAnimation(
                        child: ListTile(
                          leading: const Icon(Icons.table_chart),
                          title: const Text('CSV'),
                          subtitle: const Text(
                            'Ideal para Excel, Google Sheets',
                          ),
                          trailing: Radio<int>(
                            value: 0,
                            groupValue: 0,
                            onChanged: (value) {},
                          ),
                          onTap: () {},
                        ),
                      ),
                      AnimationUtils.fadeSlideInAnimation(
                        child: ListTile(
                          leading: const Icon(Icons.picture_as_pdf),
                          title: const Text('PDF'),
                          subtitle: const Text(
                            'Informe detallado con gráficas',
                          ),
                          trailing: Radio<int>(
                            value: 1,
                            groupValue: 0,
                            onChanged: (value) {},
                          ),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            AnimationUtils.fadeSlideInAnimation(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download),
                label: const Text('EXPORTAR'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
