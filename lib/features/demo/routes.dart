import 'package:flutter/material.dart';
import 'package:sgs_golf/features/demo/ui/components_demo_page.dart';
import 'package:sgs_golf/features/demo/ui_components_demo.dart';

/// Configuración de rutas para la sección de demostración
class DemoRoutes {
  /// Ruta base para todas las páginas de demostración
  static const String basePath = '/demo';

  /// Ruta para la página de demostración de componentes
  static const String componentsDemo = '$basePath/components';

  /// Ruta para la nueva página de demostración de componentes visuales
  static const String uiComponentsDemo = '$basePath/ui-components';

  /// Registra todas las rutas de demostración
  static Map<String, WidgetBuilder> routes() {
    return {
      componentsDemo: (context) => const ComponentsDemoPage(),
      uiComponentsDemo: (context) => const UIComponentsDemo(),
    };
  }
}
