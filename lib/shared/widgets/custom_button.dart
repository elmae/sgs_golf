import 'package:flutter/material.dart';
import 'package:sgs_golf/shared/widgets/app_button.dart';

/// Widget heredado para compatibilidad con código existente.
/// Para nuevos desarrollos, se recomienda utilizar directamente AppButton.
class CustomButton extends StatelessWidget {
  /// El texto del botón
  final String label;

  /// La acción a ejecutar cuando se presiona el botón
  final VoidCallback onPressed;

  /// Constructor del botón personalizado
  const CustomButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AppButton(text: label, onPressed: onPressed);
  }
}
