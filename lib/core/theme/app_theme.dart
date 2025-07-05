import 'package:flutter/material.dart';

/// Paleta de colores SGS Golf
///
/// - Zanahoria intensa: Botones primarios, acciones destacadas (#F54A00)
/// - Verde campo: Fondos activos, barras de progreso (#388E3C)
/// - Azul profundo: Encabezados, enlaces clave (#1976D2)
/// - Rojo alerta: Estados de error, notificaciones urgentes (#D21919)
/// - Gris suave: Fondos neutros, separadores (#E0E0E0)
/// - Gris oscuro: Texto principal, íconos, contornos (#424242)
class AppColors {
  /// Botones primarios, acciones destacadas
  static const Color zanahoriaIntensa = Color(0xFFF54A00);

  /// Fondos activos, barras de progreso
  static const Color verdeCampo = Color(0xFF388E3C);

  /// Encabezados, enlaces clave
  static const Color azulProfundo = Color(0xFF1976D2);

  /// Estados de error, notificaciones urgentes
  static const Color rojoAlerta = Color(0xFFD21919);

  /// Fondos neutros, separadores
  static const Color grisSuave = Color(0xFFE0E0E0);

  /// Texto principal, íconos, contornos
  static const Color grisOscuro = Color(0xFF424242);
}

/// Tema principal de la app SGS Golf basado en la paleta institucional.
final ThemeData appTheme = ThemeData(
  primaryColor: AppColors.zanahoriaIntensa,
  colorScheme: const ColorScheme(
    primary: AppColors.zanahoriaIntensa,
    secondary: AppColors.azulProfundo,
    surface: AppColors.grisSuave,
    error: AppColors.rojoAlerta,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: AppColors.grisOscuro,
    onError: Colors.white,
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: AppColors.grisSuave,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.azulProfundo,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.verdeCampo,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(AppColors.zanahoriaIntensa),
      foregroundColor: WidgetStatePropertyAll(Colors.white),
    ),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(color: AppColors.azulProfundo),
    bodyMedium: TextStyle(color: AppColors.grisOscuro),
  ),
  iconTheme: const IconThemeData(color: AppColors.grisOscuro),
  dividerColor: AppColors.grisSuave,
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.verdeCampo,
  ),
);
