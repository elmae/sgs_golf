import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sgs_golf/core/theme/app_theme.dart';
import 'package:sgs_golf/shared/widgets/app_chip.dart';

void main() {
  group('AppChip', () {
    testWidgets('muestra la etiqueta correctamente', (tester) async {
      const String chipLabel = 'Etiqueta de prueba';
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppChip(
                label: chipLabel,
              ),
            ),
          ),
        ),
      );

      // Verificar que la etiqueta se muestra
      expect(find.text(chipLabel), findsOneWidget);
    });

    testWidgets('aplica el color de fondo correctamente', (tester) async {
      const Color backgroundColor = AppColors.verdeCampo;
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppChip(
                label: 'Test',
                backgroundColor: backgroundColor,
              ),
            ),
          ),
        ),
      );

      // Verificar que el chip tiene el color de fondo correcto
      final chip = tester.widget<Chip>(find.byType(Chip));
      expect(chip.backgroundColor, equals(backgroundColor));
    });

    testWidgets('muestra el icono cuando se proporciona', (tester) async {
      const IconData testIcon = Icons.golf_course;
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppChip(
                label: 'Test',
                icon: testIcon,
              ),
            ),
          ),
        ),
      );

      // Verificar que el icono se muestra
      expect(find.byIcon(testIcon), findsOneWidget);
    });

    testWidgets('muestra el icono de eliminar cuando deleteIcon=true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppChip(
                label: 'Test',
                deleteIcon: true,
                onDeleted: () {},
              ),
            ),
          ),
        ),
      );

      // Verificar que existe un icono de eliminar
      final chip = tester.widget<Chip>(find.byType(Chip));
      expect(chip.onDeleted, isNotNull);
    });

    testWidgets('ejecuta onTap cuando se presiona un chip seleccionable', (tester) async {
      bool wasTapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppChip(
                label: 'Test',
                selectable: true,
                onTap: () => wasTapped = true,
              ),
            ),
          ),
        ),
      );

      // Presionar el chip
      await tester.tap(find.byType(FilterChip));
      await tester.pump();
      
      // Verificar que se ejecutó el callback
      expect(wasTapped, isTrue);
    });

    testWidgets('crea un chip primario con el color correcto', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppChip.primary(
                label: 'Chip Primario',
              ),
            ),
          ),
        ),
      );

      // Verificar que el chip tiene el color de texto correcto
      final chip = tester.widget<Chip>(find.byType(Chip));
      final labelStyle = chip.labelStyle as TextStyle;
      
      expect(labelStyle.color, equals(AppColors.zanahoriaIntensa));
    });

    testWidgets('crea un chip secundario con el color correcto', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppChip.secondary(
                label: 'Chip Secundario',
              ),
            ),
          ),
        ),
      );

      // Verificar que el chip tiene el color de texto correcto
      final chip = tester.widget<Chip>(find.byType(Chip));
      final labelStyle = chip.labelStyle as TextStyle;
      
      expect(labelStyle.color, equals(AppColors.azulProfundo));
    });

    testWidgets('crea un chip seleccionable cuando selectable=true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppChip(
                label: 'Test',
                selectable: true,
                selected: true,
              ),
            ),
          ),
        ),
      );

      // Verificar que el chip es de tipo FilterChip
      expect(find.byType(FilterChip), findsOneWidget);
      
      // Verificar que está seleccionado
      final filterChip = tester.widget<FilterChip>(find.byType(FilterChip));
      expect(filterChip.selected, isTrue);
    });
  });
}
