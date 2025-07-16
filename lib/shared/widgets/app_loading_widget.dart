import 'package:flutter/material.dart';
import 'package:sgs_golf/core/theme/app_theme.dart';

/// Widget para mostrar un estado de carga reutilizable en toda la aplicación.
///
/// Este componente muestra un indicador de progreso circular personalizable
/// y opcionalmente un mensaje descriptivo. El diseño sigue la paleta de
/// colores institucional de SGS Golf.
///
/// Ejemplo:
/// ```dart
/// AppLoadingWidget(
///   message: 'Cargando sesiones...',
///   showBackground: true,
/// )
/// ```
class AppLoadingWidget extends StatelessWidget {
  /// Mensaje opcional a mostrar debajo del indicador de carga
  final String? message;

  /// Tamaño del indicador de carga
  final double size;

  /// Grosor de la línea del indicador de carga
  final double strokeWidth;

  /// Color del indicador de carga (usa color del tema por defecto)
  final Color? color;

  /// Indica si se debe mostrar un fondo difuminado
  final bool showBackground;

  /// Opacidad del fondo cuando showBackground es true
  final double backgroundOpacity;

  const AppLoadingWidget({
    super.key,
    this.message,
    this.size = 40.0,
    this.strokeWidth = 4.0,
    this.color,
    this.showBackground = false,
    this.backgroundOpacity = 0.7,
  });

  @override
  Widget build(BuildContext context) {
    final Widget loadingIndicator = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          strokeWidth: strokeWidth,
          color: color ?? AppColors.verdeCampo,
          semanticsLabel: 'Indicador de carga',
        ),
        if (message != null)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              message!,
              style: const TextStyle(
                color: AppColors.grisOscuro,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );

    if (showBackground) {
      return Container(
        color: Colors.white.withAlpha((backgroundOpacity * 255).toInt()),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(
                    26,
                  ), // 0.1 * 255 = 25.5, redondeando a 26
                  blurRadius: 10.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: loadingIndicator,
          ),
        ),
      );
    }

    return Center(child: loadingIndicator);
  }
}
