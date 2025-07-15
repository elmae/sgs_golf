import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sgs_golf/core/theme/app_theme.dart';
import 'package:sgs_golf/shared/widgets/app_card.dart';

void main() {
  group('AppCard', () {
    testWidgets('muestra el contenido correctamente', (tester) async {
      const String testText = 'Contenido de prueba';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(child: AppCard(child: Text(testText))),
          ),
        ),
      );

      // Verificar que el contenido se muestra
      expect(find.text(testText), findsOneWidget);
    });

    testWidgets('aplica el padding correctamente', (tester) async {
      const EdgeInsets customPadding = EdgeInsets.all(24.0);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppCard(padding: customPadding, child: Text('Contenido')),
            ),
          ),
        ),
      );

      // Obtener el widget de padding
      final Padding paddingWidget = tester.widget<Padding>(
        find.descendant(
          of: find.byType(AppCard),
          matching: find.byType(Padding).last,
        ),
      );

      // Verificar que el padding sea el correcto
      expect(paddingWidget.padding, equals(customPadding));
    });

    testWidgets('aplica el color de borde cuando se especifica', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppCard(
                borderColor: AppColors.zanahoriaIntensa,
                borderWidth: 2.0,
                child: Text('Contenido'),
              ),
            ),
          ),
        ),
      );

      // Verificar que existe un Container con decoración de borde
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('ejecuta onTap cuando se presiona', (tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppCard(
                onTap: () => wasTapped = true,
                child: const Text('Contenido'),
              ),
            ),
          ),
        ),
      );

      // Presionar la tarjeta
      await tester.tap(find.byType(InkWell));
      await tester.pump();

      // Verificar que se ejecutó el callback
      expect(wasTapped, isTrue);
    });

    testWidgets('muestra encabezado cuando headerTitle está presente', (
      tester,
    ) async {
      const String headerText = 'Título del encabezado';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppCard(headerTitle: headerText, child: Text('Contenido')),
            ),
          ),
        ),
      );

      // Verificar que el título del encabezado se muestra
      expect(find.text(headerText), findsOneWidget);
    });

    testWidgets('aplica el color de encabezado correctamente', (tester) async {
      const Color headerColor = AppColors.verdeCampo;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppCard(
                headerColor: headerColor,
                headerTitle: 'Título',
                child: Text('Contenido'),
              ),
            ),
          ),
        ),
      );

      // Buscar el contenedor del encabezado y verificar su color
      final Container container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AppCard),
          matching: find.byType(Container).first,
        ),
      );

      // Verificar que la decoración contiene el color correcto
      final BoxDecoration decoration = container.decoration as BoxDecoration;
      expect(decoration.color, equals(headerColor));
    });
  });
}
