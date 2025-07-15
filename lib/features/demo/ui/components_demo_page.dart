import 'package:flutter/material.dart';
import 'package:sgs_golf/core/theme/app_theme.dart';
import 'package:sgs_golf/shared/widgets/app_button.dart';
import 'package:sgs_golf/shared/widgets/app_card.dart';
import 'package:sgs_golf/shared/widgets/app_chip.dart';

/// Página de demostración que muestra todos los componentes visuales disponibles
/// usando la paleta de colores definida.
class ComponentsDemoPage extends StatelessWidget {
  /// Constructor de la página de demostración
  const ComponentsDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Componentes SGS Golf')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarjetas
            const _SectionTitle('Tarjetas'),
            const SizedBox(height: 8),

            // Tarjeta básica
            const AppCard(child: Text('Tarjeta básica')),
            const SizedBox(height: 16),

            // Tarjeta con encabezado
            const AppCard(
              headerTitle: 'Tarjeta con encabezado',
              headerColor: AppColors.azulProfundo,
              child: Text('Contenido de la tarjeta'),
            ),
            const SizedBox(height: 16),

            // Tarjeta con borde de color
            const AppCard(
              borderColor: AppColors.zanahoriaIntensa,
              child: Text('Tarjeta con borde'),
            ),
            const SizedBox(height: 16),

            // Tarjeta con acción
            AppCard(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('¡Tarjeta presionada!')),
                );
              },
              child: const Text('Tarjeta presionable (toca aquí)'),
            ),
            const SizedBox(height: 24),

            // Botones
            const _SectionTitle('Botones'),
            const SizedBox(height: 8),

            // Botones principales
            Row(
              children: [
                Expanded(
                  child: AppButton.primary(text: 'Primario', onPressed: () {}),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppButton.secondary(
                    text: 'Secundario',
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Botones accent y danger
            Row(
              children: [
                Expanded(
                  child: AppButton.accent(text: 'Accent', onPressed: () {}),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppButton.danger(text: 'Danger', onPressed: () {}),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Botones texto y outlined
            Row(
              children: [
                Expanded(
                  child: AppButton.text(text: 'Texto', onPressed: () {}),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppButton.outlined(text: 'Outlined', onPressed: () {}),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Botones con icono
            Row(
              children: [
                Expanded(
                  child: AppButton.primary(
                    text: 'Con icono',
                    icon: Icons.add,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppButton.secondary(
                    text: 'Con icono',
                    icon: Icons.golf_course,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Botón de ancho completo
            AppButton.primary(
              text: 'Botón ancho completo',
              fullWidth: true,
              onPressed: () {},
            ),
            const SizedBox(height: 8),

            // Botón con estado de carga
            AppButton.primary(
              text: 'Cargando',
              isLoading: true,
              fullWidth: true,
              onPressed: () {},
            ),
            const SizedBox(height: 24),

            // Chips
            const _SectionTitle('Chips'),
            const SizedBox(height: 8),

            // Chips simples
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                AppChip.primary(label: 'Primario'),
                AppChip.secondary(label: 'Secundario'),
                AppChip.accent(label: 'Acento'),
                AppChip.neutral(label: 'Neutral'),
              ],
            ),
            const SizedBox(height: 8),

            // Chips con iconos
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                AppChip.primary(label: 'Con icono', icon: Icons.sports_golf),
                AppChip.secondary(label: 'Con icono', icon: Icons.timer),
                AppChip.accent(label: 'Con icono', icon: Icons.flag),
                AppChip.neutral(label: 'Con icono', icon: Icons.info),
              ],
            ),
            const SizedBox(height: 8),

            // Chips eliminables
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                AppChip.primary(
                  label: 'Eliminable',
                  deleteIcon: true,
                  onDeleted: () {},
                ),
                AppChip.secondary(
                  label: 'Eliminable',
                  deleteIcon: true,
                  onDeleted: () {},
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Chips seleccionables
            _ChipSelectionDemo(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

/// Widget para mostrar títulos de sección
class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.azulProfundo,
          ),
        ),
        const Divider(),
      ],
    );
  }
}

/// Widget de demostración para chips seleccionables
class _ChipSelectionDemo extends StatefulWidget {
  @override
  State<_ChipSelectionDemo> createState() => _ChipSelectionDemoState();
}

class _ChipSelectionDemoState extends State<_ChipSelectionDemo> {
  final List<String> _options = ['Principiante', 'Intermedio', 'Avanzado'];
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Chips seleccionables:'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _options.map((option) {
            final isSelected = option == _selectedOption;
            return AppChip(
              label: option,
              selectable: true,
              selected: isSelected,
              backgroundColor: AppColors.zanahoriaIntensa.withAlpha(
                26,
              ), // alpha 26 ~ opacity 0.1
              textColor: AppColors.zanahoriaIntensa,
              onTap: () {
                setState(() {
                  _selectedOption = isSelected ? null : option;
                });
              },
            );
          }).toList(),
        ),
        if (_selectedOption != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text('Seleccionado: $_selectedOption'),
          ),
      ],
    );
  }
}
