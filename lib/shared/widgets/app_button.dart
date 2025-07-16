import 'package:flutter/material.dart';
import 'package:sgs_golf/core/theme/app_theme.dart';
import 'package:sgs_golf/shared/utils/animation_utils.dart';

/// Enum que define los tipos de botones disponibles en la aplicación
enum AppButtonType {
  /// Botón principal con estilo destacado (fondo naranja)
  primary,

  /// Botón secundario con estilo menos destacado (fondo azul)
  secondary,

  /// Botón de acento con fondo verde
  accent,

  /// Botón de solo texto sin fondo
  text,

  /// Botón delineado sin fondo pero con borde
  outlined,

  /// Botón de alerta o peligro (fondo rojo)
  danger,
}

/// Botón personalizado que sigue el diseño y paleta de colores de SGS Golf.
///
/// Este componente está diseñado para ser reutilizado en toda la aplicación,
/// proporcionando una apariencia consistente para acciones y controles.
class AppButton extends StatelessWidget {
  /// El texto que se muestra en el botón
  final String text;

  /// La acción que se ejecutará al presionar el botón
  final VoidCallback? onPressed;

  /// El tipo de botón que determina su estilo visual
  final AppButtonType type;

  /// Icono opcional para mostrar junto al texto
  final IconData? icon;

  /// Tamaño del botón
  final Size? size;

  /// Tamaño del texto del botón
  final double? fontSize;

  /// Indica si el botón ocupa todo el ancho disponible
  final bool fullWidth;

  /// Indica si mostrar el indicador de carga en lugar del texto/icono
  final bool isLoading;

  /// Estilo personalizado para el texto del botón
  final TextStyle? textStyle;

  /// Padding personalizado para el botón
  final EdgeInsetsGeometry? padding;

  /// Constructor del widget AppButton
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.icon,
    this.size,
    this.fontSize,
    this.fullWidth = false,
    this.isLoading = false,
    this.textStyle,
    this.padding,
  });

  /// Botón de tipo primario (naranja)
  factory AppButton.primary({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    Size? size,
    double? fontSize,
    bool fullWidth = false,
    bool isLoading = false,
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,

      icon: icon,
      size: size,
      fontSize: fontSize,
      fullWidth: fullWidth,
      isLoading: isLoading,
      textStyle: textStyle,
      padding: padding,
    );
  }

  /// Botón de tipo secundario (azul)
  factory AppButton.secondary({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    Size? size,
    double? fontSize,
    bool fullWidth = false,
    bool isLoading = false,
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      type: AppButtonType.secondary,
      icon: icon,
      size: size,
      fontSize: fontSize,
      fullWidth: fullWidth,
      isLoading: isLoading,
      textStyle: textStyle,
      padding: padding,
    );
  }

  /// Botón de tipo acento (verde)
  factory AppButton.accent({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    Size? size,
    double? fontSize,
    bool fullWidth = false,
    bool isLoading = false,
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      type: AppButtonType.accent,
      icon: icon,
      size: size,
      fontSize: fontSize,
      fullWidth: fullWidth,
      isLoading: isLoading,
      textStyle: textStyle,
      padding: padding,
    );
  }

  /// Botón de tipo texto (sin fondo)
  factory AppButton.text({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    Size? size,
    double? fontSize,
    bool fullWidth = false,
    bool isLoading = false,
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      type: AppButtonType.text,
      icon: icon,
      size: size,
      fontSize: fontSize,
      fullWidth: fullWidth,
      isLoading: isLoading,
      textStyle: textStyle,
      padding: padding,
    );
  }

  /// Botón de tipo delineado (con borde)
  factory AppButton.outlined({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    Size? size,
    double? fontSize,
    bool fullWidth = false,
    bool isLoading = false,
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      type: AppButtonType.outlined,
      icon: icon,
      size: size,
      fontSize: fontSize,
      fullWidth: fullWidth,
      isLoading: isLoading,
      textStyle: textStyle,
      padding: padding,
    );
  }

  /// Botón de tipo peligro (rojo)
  factory AppButton.danger({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    Size? size,
    double? fontSize,
    bool fullWidth = false,
    bool isLoading = false,
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      type: AppButtonType.danger,
      icon: icon,
      size: size,
      fontSize: fontSize,
      fullWidth: fullWidth,
      isLoading: isLoading,
      textStyle: textStyle,
      padding: padding,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtener colores basados en el tipo de botón
    final Map<String, Color> buttonColors = _getButtonColors();

    // Determinar qué tipo de widget botón crear
    Widget buttonWidget;

    switch (type) {
      case AppButtonType.text:
        buttonWidget = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            padding: padding,
            minimumSize: size,
            textStyle: _getTextStyle(),
            foregroundColor: buttonColors['text'],
          ),
          child: _buildButtonContent(buttonColors),
        );
        break;

      case AppButtonType.outlined:
        buttonWidget = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            padding: padding,
            minimumSize: size,
            textStyle: _getTextStyle(),
            foregroundColor: buttonColors['text'],
            side: BorderSide(color: buttonColors['border']!),
          ),
          child: _buildButtonContent(buttonColors),
        );
        break;

      default:
        buttonWidget = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            padding: padding,
            minimumSize: size,
            textStyle: _getTextStyle(),
            foregroundColor: buttonColors['text'],
            backgroundColor: buttonColors['background'],
          ),
          child: _buildButtonContent(buttonColors),
        );
    }

    // Ajustar ancho si es necesario
    if (fullWidth) {
      buttonWidget = SizedBox(width: double.infinity, child: buttonWidget);
    }

    // Envolver en animaciones sutiles
    return AnimationUtils.fadeInAnimation(
      duration: AnimationUtils.quickDuration,
      child: AnimatedContainer(
        duration: AnimationUtils.defaultDuration,
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            if (onPressed != null &&
                type != AppButtonType.text &&
                type != AppButtonType.outlined)
              BoxShadow(
                color: Color.fromARGB(
                  (255 * 0.3).round(),
                  (buttonColors['background']!.r * 255.0).round(),
                  (buttonColors['background']!.g * 255.0).round(),
                  (buttonColors['background']!.b * 255.0).round(),
                ),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: buttonWidget,
      ),
    );
  }

  /// Construye el contenido interno del botón (texto, icono, indicador de carga)
  Widget _buildButtonContent(Map<String, Color> colors) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(colors['text']!),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: fontSize != null ? fontSize! + 2 : null),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }

    return Text(text);
  }

  /// Obtiene los colores para el botón según su tipo
  Map<String, Color> _getButtonColors() {
    switch (type) {
      case AppButtonType.primary:
        return {
          'background': AppColors.zanahoriaIntensa,
          'text': Colors.white,
          'border': AppColors.zanahoriaIntensa,
        };

      case AppButtonType.secondary:
        return {
          'background': AppColors.azulProfundo,
          'text': Colors.white,
          'border': AppColors.azulProfundo,
        };

      case AppButtonType.accent:
        return {
          'background': AppColors.verdeCampo,
          'text': Colors.white,
          'border': AppColors.verdeCampo,
        };

      case AppButtonType.danger:
        return {
          'background': AppColors.rojoAlerta,
          'text': Colors.white,
          'border': AppColors.rojoAlerta,
        };

      case AppButtonType.text:
        return {
          'background': Colors.transparent,
          'text': AppColors.azulProfundo,
          'border': Colors.transparent,
        };

      case AppButtonType.outlined:
        return {
          'background': Colors.transparent,
          'text': AppColors.azulProfundo,
          'border': AppColors.azulProfundo,
        };
    }
  }

  /// Obtiene el estilo de texto para el botón
  TextStyle? _getTextStyle() {
    if (textStyle != null) return textStyle;

    return fontSize != null ? TextStyle(fontSize: fontSize) : null;
  }
}
