import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sgs_golf/core/theme/app_theme.dart';
import 'package:sgs_golf/shared/widgets/app_empty_state_widget.dart';

void main() {
  testWidgets(
    'AppEmptyStateWidget muestra icono, título y mensaje correctamente',
    (tester) async {
      const testIcon = Icons.info;
      const testTitle = 'Título de prueba';
      const testMessage = 'Mensaje de prueba';

      // Construir nuestro widget y activar un frame.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppEmptyStateWidget(
              icon: testIcon,
              title: testTitle,
              message: testMessage,
            ),
          ),
        ),
      );

      // Verificar que se muestran el icono, título y mensaje
      expect(find.byIcon(testIcon), findsOneWidget);
      expect(find.text(testTitle), findsOneWidget);
      expect(find.text(testMessage), findsOneWidget);

      // Verificar que no hay botón cuando no se proporciona
      expect(find.byType(ElevatedButton), findsNothing);
    },
  );

  testWidgets(
    'AppEmptyStateWidget muestra un botón cuando se proporcionan buttonText y onButtonPressed',
    (tester) async {
      const testButtonText = 'Botón de prueba';
      bool buttonPressed = false;

      // Construir nuestro widget y activar un frame.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppEmptyStateWidget(
              icon: Icons.info,
              title: 'Título',
              message: 'Mensaje',
              buttonText: testButtonText,
              onButtonPressed: () {
                buttonPressed = true;
              },
            ),
          ),
        ),
      );

      // Verificar que se muestra el botón con el texto correcto
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text(testButtonText), findsOneWidget);

      // Probar que el botón funciona
      await tester.tap(find.byType(ElevatedButton));
      expect(buttonPressed, isTrue);
    },
  );

  testWidgets(
    'AppEmptyStateWidget usa color personalizado para el icono cuando se proporciona',
    (tester) async {
      const customColor = Colors.red;

      // Construir nuestro widget y activar un frame.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppEmptyStateWidget(
              icon: Icons.info,
              title: 'Título',
              message: 'Mensaje',
              iconColor: customColor,
            ),
          ),
        ),
      );

      // Buscar el Icon y verificar su color
      final Icon iconWidget = tester.widget(find.byType(Icon));
      expect(iconWidget.color, equals(customColor));
    },
  );

  testWidgets(
    'AppEmptyStateWidget usa color por defecto para el icono cuando no se proporciona',
    (tester) async {
      // Construir nuestro widget y activar un frame.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppEmptyStateWidget(
              icon: Icons.info,
              title: 'Título',
              message: 'Mensaje',
            ),
          ),
        ),
      ); // Buscar el Icon y verificar su color
      final Icon iconWidget = tester.widget(find.byType(Icon));
      expect(
        iconWidget.color,
        equals(AppColors.azulProfundo.withAlpha(178)),
      ); // 0.7 * 255 = 178
    },
  );
}
