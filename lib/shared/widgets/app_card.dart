import 'package:flutter/material.dart';
import 'package:sgs_golf/core/theme/app_theme.dart';

/// Tarjeta personalizable que sigue el diseño y paleta de colores de SGS Golf.
///
/// Este componente está diseñado para ser reutilizado en toda la aplicación,
/// proporcionando una apariencia consistente para mostrar información y contenido.
class AppCard extends StatelessWidget {
  /// Contenido principal de la tarjeta
  final Widget child;

  /// Color de fondo de la tarjeta (por defecto blanco)
  final Color? backgroundColor;

  /// Elevación de la tarjeta (por defecto 2.0)
  final double elevation;

  /// Margen externo de la tarjeta
  final EdgeInsetsGeometry? margin;

  /// Padding interno de la tarjeta
  final EdgeInsetsGeometry padding;

  /// Radio del borde de la tarjeta
  final double borderRadius;

  /// Color del borde opcional
  final Color? borderColor;

  /// Ancho del borde (si borderColor no es null)
  final double borderWidth;

  /// Callback que se ejecuta al presionar la tarjeta
  final VoidCallback? onTap;

  /// Opcional - Color de la barra superior
  final Color? headerColor;

  /// Opcional - Título de la barra superior
  final String? headerTitle;

  /// Opcional - Estilo del texto del título
  final TextStyle? headerTitleStyle;

  /// Constructor del widget AppCard
  const AppCard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.elevation = 2.0,
    this.margin,
    this.padding = const EdgeInsets.all(16.0),
    this.borderRadius = 12.0,
    this.borderColor,
    this.borderWidth = 1.0,
    this.onTap,
    this.headerColor,
    this.headerTitle,
    this.headerTitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final finalBorderRadius = BorderRadius.circular(borderRadius);

    // Determinar si tiene encabezado
    final hasHeader = headerTitle != null || headerColor != null;

    // Crear decoración de borde
    BoxDecoration? borderDecoration;
    if (borderColor != null) {
      borderDecoration = BoxDecoration(
        border: Border.all(color: borderColor!, width: borderWidth),
        borderRadius: finalBorderRadius,
      );
    }

    // Crear el contenido de la tarjeta
    Widget cardContent = Padding(padding: padding, child: child);

    // Si tiene encabezado, añadirlo
    if (hasHeader) {
      cardContent = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: headerColor ?? AppColors.azulProfundo.withAlpha(25), // alpha 25 ~ opacity 0.1
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                topRight: Radius.circular(borderRadius),
              ),
            ),
            width: double.infinity,
            child: headerTitle != null
                ? Text(
                    headerTitle!,
                    style:
                        headerTitleStyle ??
                        TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              headerColor != null &&
                                  headerColor!.computeLuminance() > 0.5
                              ? Colors.black
                              : Colors.white,
                        ),
                  )
                : null,
          ),
          Padding(padding: padding, child: child),
        ],
      );
    }

    // Crear la tarjeta completa con o sin acción de tap
    return Card(
      margin: margin,
      elevation: elevation,
      shape: RoundedRectangleBorder(borderRadius: finalBorderRadius),
      color: backgroundColor,
      child: borderColor != null
          ? Container(
              decoration: borderDecoration,
              child: _wrapWithInkWell(cardContent, finalBorderRadius),
            )
          : _wrapWithInkWell(cardContent, finalBorderRadius),
    );
  }

  /// Envuelve el contenido en un InkWell si existe onTap
  Widget _wrapWithInkWell(Widget content, BorderRadius borderRadius) {
    if (onTap == null) return content;

    return InkWell(onTap: onTap, borderRadius: borderRadius, child: content);
  }
}
