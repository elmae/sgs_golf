import 'package:flutter/material.dart';
import 'package:sgs_golf/core/theme/app_theme.dart';
import 'package:sgs_golf/shared/widgets/app_button.dart';
import 'package:sgs_golf/shared/widgets/app_card.dart';
import 'package:sgs_golf/shared/widgets/app_chip.dart';

/// Pantalla de demostración que muestra todos los componentes visuales
/// desarrollados para SGS Golf.
///
/// Esta pantalla sirve como referencia visual y documentación interactiva
/// para los desarrolladores.
class UIComponentsDemo extends StatelessWidget {
  /// Ruta para acceder a la pantalla de demostración
  static const String route = '/ui-components-demo';

  /// Constructor de la pantalla de demostración
  const UIComponentsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Componentes Visuales SGS Golf')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Tarjetas (AppCard)'),
            const SizedBox(height: 16),
            _buildCardExamples(),
            const SizedBox(height: 32),

            _buildSectionTitle('Botones (AppButton)'),
            const SizedBox(height: 16),
            _buildButtonExamples(),
            const SizedBox(height: 32),

            _buildSectionTitle('Chips (AppChip)'),
            const SizedBox(height: 16),
            _buildChipExamples(),
            const SizedBox(height: 32),

            _buildSectionTitle('Paleta de Colores'),
            const SizedBox(height: 16),
            _buildColorPalette(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// Construye un título de sección con el estilo adecuado
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.azulProfundo,
      ),
    );
  }

  /// Construye la demostración de tarjetas
  Widget _buildCardExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Tarjeta básica
        const AppCard(
          child: Text('Tarjeta básica con padding predeterminado.'),
        ),
        const SizedBox(height: 16),

        // Tarjeta con encabezado
        const AppCard(
          headerTitle: 'Tarjeta con encabezado',
          child: Text('Esta tarjeta tiene un encabezado con título.'),
        ),
        const SizedBox(height: 16),

        // Tarjeta con encabezado de color
        const AppCard(
          headerTitle: 'Encabezado de color',
          headerColor: AppColors.zanahoriaIntensa,
          child: Text(
            'Esta tarjeta tiene un encabezado con color personalizado.',
          ),
        ),
        const SizedBox(height: 16),

        // Tarjeta con borde
        const AppCard(
          borderColor: AppColors.verdeCampo,
          borderWidth: 2.0,
          child: Text('Esta tarjeta tiene un borde de color verde.'),
        ),
        const SizedBox(height: 16),

        // Tarjeta con acción de tap
        AppCard(
          headerTitle: 'Tarjeta con acción',
          headerColor: AppColors.azulProfundo,
          onTap: () {
            ScaffoldMessenger.of(globalContext).showSnackBar(
              const SnackBar(content: Text('¡Tarjeta presionada!')),
            );
          },
          child: const Text('Toca esta tarjeta para ver una acción.'),
        ),
      ],
    );
  }

  /// Construye la demostración de botones
  Widget _buildButtonExamples() {
    return Wrap(
      spacing: 8,
      runSpacing: 16,
      children: [
        // Botón primario
        AppButton.primary(
          text: 'Botón Primario',
          onPressed: () {
            ScaffoldMessenger.of(globalContext).showSnackBar(
              const SnackBar(content: Text('Botón primario presionado')),
            );
          },
        ),
        const SizedBox(width: 8),

        // Botón secundario
        AppButton.secondary(text: 'Botón Secundario', onPressed: () {}),
        const SizedBox(width: 8),

        // Botón de acento
        AppButton.accent(text: 'Botón Acento', onPressed: () {}),
        const SizedBox(width: 8),

        // Botón de texto
        AppButton.text(text: 'Botón de Texto', onPressed: () {}),
        const SizedBox(width: 8),

        // Botón delineado
        AppButton.outlined(text: 'Botón Delineado', onPressed: () {}),
        const SizedBox(width: 8),

        // Botón de peligro
        AppButton.danger(text: 'Botón de Peligro', onPressed: () {}),
        const SizedBox(width: 8),

        // Botón con icono
        AppButton.primary(
          text: 'Con Icono',
          icon: Icons.golf_course,
          onPressed: () {},
        ),
        const SizedBox(width: 8),

        // Botón cargando
        AppButton.primary(text: 'Cargando', isLoading: true, onPressed: null),
      ],
    );
  }

  /// Construye la demostración de chips
  Widget _buildChipExamples() {
    return Wrap(
      spacing: 8,
      runSpacing: 12,
      children: [
        // Chip primario
        AppChip.primary(label: 'Chip Primario'),

        // Chip secundario
        AppChip.secondary(label: 'Chip Secundario'),

        // Chip acento
        AppChip.accent(label: 'Chip Acento'),

        // Chip neutral
        AppChip.neutral(label: 'Chip Neutral'),

        // Chip con icono
        AppChip.primary(label: 'Con Icono', icon: Icons.golf_course),

        // Chip seleccionable
        AppChip(
          label: 'Seleccionable',
          selectable: true,
          backgroundColor: AppColors.verdeCampo.withAlpha(
            38,
          ), // alpha 38 ~ opacity 0.15
          textColor: AppColors.verdeCampo,
          onTap: () {},
        ),

        // Chip seleccionado
        AppChip(
          label: 'Seleccionado',
          selectable: true,
          selected: true,
          backgroundColor: AppColors.verdeCampo,
          textColor: Colors.white,
          onTap: () {},
        ),

        // Chip con opción de eliminar
        AppChip.secondary(
          label: 'Eliminable',
          deleteIcon: true,
          onDeleted: () {
            ScaffoldMessenger.of(
              globalContext,
            ).showSnackBar(const SnackBar(content: Text('Chip eliminado')));
          },
        ),
      ],
    );
  }

  /// Construye la demostración de la paleta de colores
  Widget _buildColorPalette() {
    return Column(
      children: [
        _buildColorItem('Zanahoria Intensa', AppColors.zanahoriaIntensa),
        _buildColorItem('Verde Campo', AppColors.verdeCampo),
        _buildColorItem('Azul Profundo', AppColors.azulProfundo),
        _buildColorItem('Rojo Alerta', AppColors.rojoAlerta),
        _buildColorItem('Gris Suave', AppColors.grisSuave),
        _buildColorItem('Gris Oscuro', AppColors.grisOscuro),
      ],
    );
  }

  /// Construye un elemento individual para mostrar un color de la paleta
  Widget _buildColorItem(String name, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black12),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                '0x${color.toARGB32().toRadixString(16).toUpperCase()}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Contexto global para acceder al ScaffoldMessenger
  BuildContext get globalContext => navigatorKey.currentContext!;
}

/// Clave global para el navegador, necesaria para mostrar SnackBars desde
/// funciones fuera del contexto del widget
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
