/// app_router.dart
library app_router;

///
/// Esquema centralizado de rutas nombradas para la navegación principal de la app SGS Golf.
///
/// Rutas principales:
/// - [AppRoutes.login]     → Pantalla de inicio de sesión
/// - [AppRoutes.register]  → Pantalla de registro de usuario
/// - [AppRoutes.dashboard] → Panel principal tras autenticación
/// - [AppRoutes.practice]  → Módulo de práctica de tiros
/// - [AppRoutes.analysis]  → Análisis de desempeño y estadísticas
/// - [AppRoutes.export]    → Exportación de datos y reportes
///
/// Para navegar, utiliza: `Navigator.pushNamed(context, AppRoutes.login);`
///
/// Cumple tarea 1.6.3 de [tasks-prd-sgs-golf.md](../../docs/tasks-prd-sgs-golf.md)
import 'package:flutter/material.dart';

/// Definición de rutas nombradas para las pantallas principales.
class AppRoutes {
  /// Ruta para la pantalla de inicio de sesión.
  static const String login = '/login';

  /// Ruta para la pantalla de registro de usuario.
  static const String register = '/register';

  /// Ruta para el dashboard principal.
  static const String dashboard = '/dashboard';

  /// Ruta para la pantalla de práctica.
  static const String practice = '/practice';

  /// Ruta para la pantalla de análisis.
  static const String analysis = '/analysis';

  /// Ruta para la pantalla de exportación de datos.
  static const String export = '/export';
}

// RouterDelegate y RouteInformationParser para Navigator 2.0
class AppRouterDelegate extends RouterDelegate<RouteSettings>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteSettings> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  RouteSettings _current;

  AppRouterDelegate()
    : navigatorKey = GlobalKey<NavigatorState>(),
      _current = const RouteSettings(name: AppRoutes.login);

  @override
  RouteSettings get currentConfiguration => _current;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (_current.name == AppRoutes.login)
          const MaterialPage(child: Placeholder(), name: AppRoutes.login),
        if (_current.name == AppRoutes.register)
          const MaterialPage(child: Placeholder(), name: AppRoutes.register),
        if (_current.name == AppRoutes.dashboard)
          const MaterialPage(child: Placeholder(), name: AppRoutes.dashboard),
        if (_current.name == AppRoutes.practice)
          const MaterialPage(child: Placeholder(), name: AppRoutes.practice),
        if (_current.name == AppRoutes.analysis)
          const MaterialPage(child: Placeholder(), name: AppRoutes.analysis),
        if (_current.name == AppRoutes.export)
          const MaterialPage(child: Placeholder(), name: AppRoutes.export),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        // Por simplicidad, siempre vuelve al login
        _current = const RouteSettings(name: AppRoutes.login);
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(RouteSettings configuration) async {
    _current = configuration;
    notifyListeners();
  }
}

class AppRouteInformationParser extends RouteInformationParser<RouteSettings> {
  @override
  Future<RouteSettings> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = routeInformation.uri;
    switch (uri.path) {
      case AppRoutes.login:
        return const RouteSettings(name: AppRoutes.login);
      case AppRoutes.register:
        return const RouteSettings(name: AppRoutes.register);
      case AppRoutes.dashboard:
        return const RouteSettings(name: AppRoutes.dashboard);
      case AppRoutes.practice:
        return const RouteSettings(name: AppRoutes.practice);
      case AppRoutes.analysis:
        return const RouteSettings(name: AppRoutes.analysis);
      case AppRoutes.export:
        return const RouteSettings(name: AppRoutes.export);
      default:
        return const RouteSettings(name: AppRoutes.login);
    }
  }

  @override
  RouteInformation? restoreRouteInformation(RouteSettings configuration) {
    return RouteInformation(
      uri: configuration.name != null ? Uri.parse(configuration.name!) : null,
    );
  }
}
