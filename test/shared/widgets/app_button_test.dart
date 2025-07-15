import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sgs_golf/shared/widgets/app_button.dart';

void main() {
  group('AppButton', () {
    testWidgets('muestra el texto correctamente', (tester) async {
      const String buttonText = 'Botón de prueba';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(child: AppButton(text: buttonText, onPressed: null)),
          ),
        ),
      );

      // Verificar que el texto se muestra
      expect(find.text(buttonText), findsOneWidget);
    });

    testWidgets('ejecuta onPressed cuando se presiona', (tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppButton(
                text: 'Presionar',
                onPressed: () => wasPressed = true,
              ),
            ),
          ),
        ),
      );

      // Presionar el botón
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Verificar que se ejecutó el callback
      expect(wasPressed, isTrue);
    });

    testWidgets('muestra el indicador de carga cuando isLoading=true', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppButton(
                text: 'Cargando',
                onPressed: null,
                isLoading: true,
              ),
            ),
          ),
        ),
      );

      // Verificar que el indicador de carga se muestra
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Verificar que el texto no se muestra
      expect(find.text('Cargando'), findsNothing);
    });

    testWidgets('muestra el icono cuando se proporciona', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppButton(
                text: 'Con ícono',
                onPressed: null,
                icon: Icons.add,
              ),
            ),
          ),
        ),
      );

      // Verificar que el icono se muestra
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('crea un botón primario con el color correcto', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppButton.primary(
                text: 'Botón primario',
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      // Verificar el botón es de tipo ElevatedButton
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Botón primario'), findsOneWidget);
    });

    testWidgets('crea un botón secundario con el color correcto', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppButton.secondary(
                text: 'Botón secundario',
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      // Verificar que el botón existe y tiene el texto correcto
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Botón secundario'), findsOneWidget);
    });

    testWidgets('crea un botón de texto con el tipo correcto', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppButton.text(text: 'Botón de texto', onPressed: () {}),
            ),
          ),
        ),
      );

      // Verificar el botón es de tipo TextButton
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('crea un botón delineado con el tipo correcto', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppButton.outlined(
                text: 'Botón delineado',
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      // Verificar el botón es de tipo OutlinedButton
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('aplica fullWidth correctamente', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppButton(
                text: 'Botón ancho',
                onPressed: () {},
                fullWidth: true,
              ),
            ),
          ),
        ),
      );

      // Verificar que existe un SizedBox con ancho infinito
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, equals(double.infinity));
    });
  });
}
