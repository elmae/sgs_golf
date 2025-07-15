import 'package:flutter/material.dart';
import 'package:sgs_golf/core/theme/app_theme.dart';

/// Chip personalizado que sigue el diseño y paleta de colores de SGS Golf.
///
/// Este componente está diseñado para ser utilizado como etiqueta, filtro,
/// o indicador en la aplicación, proporcionando una apariencia consistente.
class AppChip extends StatelessWidget {
  /// El texto que se muestra en el chip
  final String label;

  /// El color de fondo del chip (usará un valor de la paleta por defecto)
  final Color? backgroundColor;

  /// El color del texto del chip
  final Color? textColor;

  /// El icono opcional para mostrar junto al texto
  final IconData? icon;

  /// El color del icono (si no se especifica, usa textColor)
  final Color? iconColor;

  /// Indica si el chip es seleccionable o informativo
  final bool selectable;

  /// Indica si el chip está seleccionado (solo si selectable=true)
  final bool selected;

  /// Callback que se ejecuta al presionar el chip
  final VoidCallback? onTap;

  /// Callback que se ejecuta al eliminar el chip (si deleteIcon=true)
  final VoidCallback? onDeleted;

  /// Muestra un icono de eliminación en el chip
  final bool deleteIcon;

  /// Constructor del widget AppChip
  const AppChip({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.iconColor,
    this.selectable = false,
    this.selected = false,
    this.onTap,
    this.onDeleted,
    this.deleteIcon = false,
  });

  /// Crea un chip informativo con el color naranja
  factory AppChip.primary({
    Key? key,
    required String label,
    IconData? icon,
    bool selectable = false,
    bool selected = false,
    VoidCallback? onTap,
    VoidCallback? onDeleted,
    bool deleteIcon = false,
  }) {
    return AppChip(
      key: key,
      label: label,
      backgroundColor: AppColors.zanahoriaIntensa.withAlpha(
        38,
      ), // alpha 38 ~ opacity 0.15
      textColor: AppColors.zanahoriaIntensa,
      iconColor: AppColors.zanahoriaIntensa,
      icon: icon,
      selectable: selectable,
      selected: selected,
      onTap: onTap,
      onDeleted: onDeleted,
      deleteIcon: deleteIcon,
    );
  }

  /// Crea un chip informativo con el color verde
  factory AppChip.accent({
    Key? key,
    required String label,
    IconData? icon,
    bool selectable = false,
    bool selected = false,
    VoidCallback? onTap,
    VoidCallback? onDeleted,
    bool deleteIcon = false,
  }) {
    return AppChip(
      key: key,
      label: label,
      backgroundColor: AppColors.verdeCampo.withAlpha(
        38,
      ), // alpha 38 ~ opacity 0.15
      textColor: AppColors.verdeCampo,
      iconColor: AppColors.verdeCampo,
      icon: icon,
      selectable: selectable,
      selected: selected,
      onTap: onTap,
      onDeleted: onDeleted,
      deleteIcon: deleteIcon,
    );
  }

  /// Crea un chip informativo con el color azul
  factory AppChip.secondary({
    Key? key,
    required String label,
    IconData? icon,
    bool selectable = false,
    bool selected = false,
    VoidCallback? onTap,
    VoidCallback? onDeleted,
    bool deleteIcon = false,
  }) {
    return AppChip(
      key: key,
      label: label,
      backgroundColor: AppColors.azulProfundo.withAlpha(
        38,
      ), // alpha 38 ~ opacity 0.15
      textColor: AppColors.azulProfundo,
      iconColor: AppColors.azulProfundo,
      icon: icon,
      selectable: selectable,
      selected: selected,
      onTap: onTap,
      onDeleted: onDeleted,
      deleteIcon: deleteIcon,
    );
  }

  /// Crea un chip informativo con el color gris
  factory AppChip.neutral({
    Key? key,
    required String label,
    IconData? icon,
    bool selectable = false,
    bool selected = false,
    VoidCallback? onTap,
    VoidCallback? onDeleted,
    bool deleteIcon = false,
  }) {
    return AppChip(
      key: key,
      label: label,
      backgroundColor: AppColors.grisOscuro.withAlpha(
        25,
      ), // alpha 25 ~ opacity 0.1
      textColor: AppColors.grisOscuro,
      iconColor: AppColors.grisOscuro,
      icon: icon,
      selectable: selectable,
      selected: selected,
      onTap: onTap,
      onDeleted: onDeleted,
      deleteIcon: deleteIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Si es seleccionable, crear un FilterChip o un ChoiceChip
    if (selectable) {
      return FilterChip(
        label: _buildChipContent(),
        selected: selected,
        onSelected: onTap != null ? (_) => onTap!() : null,
        backgroundColor:
            backgroundColor ??
            AppColors.grisSuave.withAlpha(76), // alpha 76 ~ opacity 0.3
        selectedColor: selected
            ? (backgroundColor ?? AppColors.azulProfundo)
            : backgroundColor?.withAlpha(51) ??
                  AppColors.grisSuave.withAlpha(51), // alpha 51 ~ opacity 0.2
        labelStyle: TextStyle(
          color: selected
              ? (textColor != null ? Colors.white : Colors.white)
              : (textColor ?? AppColors.grisOscuro),
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        showCheckmark: false,
      );
    }

    // Si no es seleccionable, crear un Chip básico
    return Chip(
      label: _buildChipContent(),
      backgroundColor:
          backgroundColor ??
          AppColors.grisSuave.withAlpha(76), // alpha 76 ~ opacity 0.3
      labelStyle: TextStyle(color: textColor ?? AppColors.grisOscuro),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      onDeleted: deleteIcon ? onDeleted : null,
      deleteIconColor: textColor ?? AppColors.grisOscuro,
    );
  }

  /// Construye el contenido interno del chip (texto e icono)
  Widget _buildChipContent() {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: selected
                ? Colors.white
                : (iconColor ?? textColor ?? AppColors.grisOscuro),
          ),
          const SizedBox(width: 4),
          Text(label),
        ],
      );
    }
    return Text(label);
  }
}
