import 'package:flutter/material.dart';
import 'package:sgs_golf/core/theme/app_theme.dart';

/// Widget para mostrar estados vacíos o sin datos en toda la aplicación.
///
/// Este componente muestra una ilustración (icono) y un mensaje descriptivo
/// cuando no hay datos disponibles para mostrar, con un botón de acción opcional.
/// El diseño sigue la paleta de colores institucional de SGS Golf.
///
/// Ejemplo:
/// ```dart
/// AppEmptyStateWidget(
///   icon: Icons.sports_golf,
///   title: 'No hay sesiones',
///   message: 'Aún no has registrado sesiones de práctica',
///   buttonText: 'Crear sesión',
///   onButtonPressed: () => Navigator.pushNamed(context, '/practice'),
/// )
/// ```
class AppEmptyStateWidget extends StatelessWidget {
  /// Icono a mostrar
  final IconData icon;

  /// Título para el estado vacío
  final String title;

  /// Mensaje descriptivo
  final String message;

  /// Texto del botón de acción (opcional)
  final String? buttonText;

  /// Función callback para el botón (opcional)
  final VoidCallback? onButtonPressed;

  /// Tamaño del icono
  final double iconSize;

  /// Color del icono (usa color del tema por defecto)
  final Color? iconColor;

  const AppEmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.buttonText,
    this.onButtonPressed,
    this.iconSize = 80.0,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize,
              color:
                  iconColor ??
                  AppColors.azulProfundo.withAlpha(178), // 0.7 * 255 = 178
              semanticLabel: 'Icono de estado vacío',
            ),
            const SizedBox(height: 24.0),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: AppColors.grisOscuro,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12.0),
            Text(
              message,
              style: TextStyle(
                fontSize: 16.0,
                color: AppColors.grisOscuro.withAlpha(204), // 0.8 * 255 = 204
              ),
              textAlign: TextAlign.center,
            ),
            if (buttonText != null && onButtonPressed != null)
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: ElevatedButton(
                  onPressed: onButtonPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.zanahoriaIntensa,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    buttonText!,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
