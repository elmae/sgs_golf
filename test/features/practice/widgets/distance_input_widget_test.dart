import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sgs_golf/features/practice/distance_input_widget.dart';

void main() {
  testWidgets('Muestra el valor inicial correctamente', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: DistanceInputWidget(value: 50, onChanged: (_) {})),
      ),
    );
    expect(find.text('50.0'), findsOneWidget);
  });

  testWidgets('Solo acepta valores numéricos válidos', (tester) async {
    double? value;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: DistanceInputWidget(onChanged: (v) => value = v)),
      ),
    );
    await tester.enterText(find.byType(TextField), 'abc');
    expect(value, isNull);
    await tester.enterText(find.byType(TextField), '120');
    expect(value, 120);
  });

  testWidgets(
    'Valida rango razonable para golf (10-200) y muestra mensaje de error',
    (tester) async {
      double? value;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DistanceInputWidget(onChanged: (v) => value = v),
          ),
        ),
      );
      // Valor menor al rango
      await tester.enterText(find.byType(TextField), '5');
      await tester.pumpAndSettle();
      expect(find.textContaining('rango'), findsOneWidget);
      // Valor mayor al rango
      await tester.enterText(find.byType(TextField), '250');
      await tester.pumpAndSettle();
      expect(find.textContaining('rango'), findsOneWidget);
      // Valor válido
      await tester.enterText(find.byType(TextField), '80');
      await tester.pumpAndSettle();
      expect(find.textContaining('rango'), findsNothing);
      expect(value, 80);
    },
  );
}
