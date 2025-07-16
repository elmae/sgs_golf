import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sgs_golf/core/theme/app_theme.dart';
import 'package:sgs_golf/shared/widgets/app_loading_widget.dart';

void main() {
  testWidgets('AppLoadingWidget muestra un indicador de carga circular', (
    tester,
  ) async {
    // Construir nuestro widget y activar un frame.
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: AppLoadingWidget())),
    );

    // Verificar que se muestra un CircularProgressIndicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Verificar que no hay mensajes cuando no se proporciona ninguno
    expect(find.byType(Text), findsNothing);
  });

  testWidgets(
    'AppLoadingWidget muestra un mensaje personalizado cuando se proporciona',
    (tester) async {
      const testMessage = 'Cargando datos...';

      // Construir nuestro widget y activar un frame.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppLoadingWidget(message: testMessage)),
        ),
      );

      // Verificar que se muestra el mensaje proporcionado
      expect(find.text(testMessage), findsOneWidget);
    },
  );

  testWidgets(
    'AppLoadingWidget muestra un fondo cuando showBackground es true',
    (tester) async {
      // Construir nuestro widget y activar un frame.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppLoadingWidget(showBackground: true)),
        ),
      );

      // Verificar que hay un Container con un color de fondo
      expect(find.byType(Container), findsWidgets);
    },
  );

  testWidgets(
    'AppLoadingWidget usa color personalizado cuando se proporciona',
    (tester) async {
      const customColor = Colors.red;

      // Construir nuestro widget y activar un frame.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppLoadingWidget(color: customColor)),
        ),
      );

      // Buscar el CircularProgressIndicator y verificar su color
      final CircularProgressIndicator progressIndicator = tester.widget(
        find.byType(CircularProgressIndicator),
      );
      expect(progressIndicator.color, equals(customColor));
    },
  );

  testWidgets(
    'AppLoadingWidget usa color por defecto cuando no se proporciona color personalizado',
    (tester) async {
      // Construir nuestro widget y activar un frame.
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: AppLoadingWidget())),
      );

      // Buscar el CircularProgressIndicator y verificar su color
      final CircularProgressIndicator progressIndicator = tester.widget(
        find.byType(CircularProgressIndicator),
      );
      expect(progressIndicator.color, equals(AppColors.verdeCampo));
    },
  );
}
