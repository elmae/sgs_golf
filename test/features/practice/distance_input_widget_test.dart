import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sgs_golf/features/practice/distance_input_widget.dart';

void main() {
  testWidgets('DistanceInputWidget muestra valor inicial correctamente', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DistanceInputWidget(value: 75.0, onChanged: (value) {}),
        ),
      ),
    );

    // Verificar que el valor inicial se muestra correctamente
    expect(find.text('75.0'), findsOneWidget);
  });

  testWidgets('DistanceInputWidget acepta entrada válida', (tester) async {
    double? capturedValue;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DistanceInputWidget(
            onChanged: (value) => capturedValue = value,
          ),
        ),
      ),
    );

    // Ingresar un valor válido
    await tester.enterText(find.byType(TextField), '85.5');
    await tester.pump();

    // Verificar que no hay mensaje de error
    expect(find.text('Ingrese un número válido'), findsNothing);
    expect(find.text('Distancia fuera de rango (10-200 m)'), findsNothing);

    // Verificar que el valor es capturado correctamente
    expect(capturedValue, 85.5);
  });

  testWidgets('DistanceInputWidget muestra error con entrada no numérica', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: DistanceInputWidget(onChanged: (value) {})),
      ),
    );

    // Intentar ingresar un valor no numérico (debería ser filtrado por el formatter)
    await tester.enterText(find.byType(TextField), 'abc');
    await tester.pump();

    // Verificar que el texto ingresado es filtrado
    expect(find.text('abc'), findsNothing);
  });

  testWidgets('DistanceInputWidget muestra error con valor fuera de rango', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: DistanceInputWidget(onChanged: (value) {})),
      ),
    );

    // Ingresar un valor fuera del rango máximo
    await tester.enterText(find.byType(TextField), '250');
    await tester.pump();

    // Simular que pierde el foco para activar la validación completa
    await tester.tap(find.byType(Scaffold));
    await tester.pump();

    // Verificar que hay al menos un mensaje de error con ese texto
    expect(
      find.text('Distancia fuera de rango (10-200 m)'),
      findsAtLeastNWidgets(1),
    );
  });

  testWidgets('DistanceInputWidget acepta rangos personalizados', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DistanceInputWidget(
            onChanged: (value) {},
            minRange: 20.0,
            maxRange: 100.0,
          ),
        ),
      ),
    );

    // Ingresar un valor fuera del rango personalizado
    await tester.enterText(find.byType(TextField), '15');
    await tester.pump();

    // Simular que pierde el foco para activar la validación completa
    await tester.tap(find.byType(Scaffold));
    await tester.pump();

    // Verificar que hay al menos un mensaje de error con el rango personalizado
    expect(
      find.text('Distancia fuera de rango (20-100 m)'),
      findsAtLeastNWidgets(1),
    );
  });
}
