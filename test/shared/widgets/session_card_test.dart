import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sgs_golf/core/theme/app_theme.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/practice_session.dart';
import 'package:sgs_golf/data/models/shot.dart';
import 'package:sgs_golf/shared/widgets/session_card.dart';

void main() {
  final testSession = PracticeSession(
    date: DateTime.now().subtract(const Duration(days: 1)),
    duration: const Duration(minutes: 45),
    shots: [
      Shot(
        clubType: GolfClubType.pw,
        distance: 95.0,
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      ),
      Shot(
        clubType: GolfClubType.sw,
        distance: 85.0,
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
      ),
    ],
    summary: 'Resumen de la sesión de prueba',
  );

  testWidgets('SessionCard muestra la información básica correctamente', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: appTheme,
        home: Scaffold(body: SessionCard(session: testSession)),
      ),
    );

    // Verificar fecha
    final sessionDate = testSession.date;
    expect(
      find.text('${sessionDate.day}/${sessionDate.month}/${sessionDate.year}'),
      findsOneWidget,
    );

    // Verificar estadísticas básicas
    expect(find.text('45 min'), findsOneWidget); // Duración
    expect(find.text('2'), findsOneWidget); // Total de tiros
    expect(find.text('90.0m'), findsOneWidget); // Distancia promedio

    // Verificar resumen
    expect(find.text('Resumen de la sesión de prueba'), findsOneWidget);

    // No debe mostrar detalles de palos en modo básico
    expect(find.text('Desglose por palo:'), findsNothing);
  });

  testWidgets('SessionCard muestra detalles completos cuando se solicita', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: appTheme,
        home: Scaffold(
          body: SessionCard(session: testSession, showFullDetails: true),
        ),
      ),
    );

    // En modo detalle debe mostrar el desglose por tipo de palo
    expect(find.text('Desglose por palo:'), findsOneWidget);

    // Ahora verificamos el contenido usando RichText
    // que contiene la información de los palos
    expect(find.byType(RichText), findsWidgets);

    // Verificamos que hayan Chips para cada tipo de palo
    expect(find.byType(Chip), findsNWidgets(2)); // PW y SW
  });

  testWidgets('SessionCard llama a onTap cuando se presiona', (tester) async {
    bool tapCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: appTheme,
        home: Scaffold(
          body: SessionCard(
            session: testSession,
            onTap: () => tapCalled = true,
          ),
        ),
      ),
    );

    // Presionar la tarjeta
    await tester.tap(find.byType(InkWell));
    expect(tapCalled, isTrue);
  });

  testWidgets('SessionCard muestra botón de eliminar y llama onDelete', (
    tester,
  ) async {
    bool deleteCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: appTheme,
        home: Scaffold(
          body: SessionCard(
            session: testSession,
            onDelete: () => deleteCalled = true,
          ),
        ),
      ),
    );

    // Verificar que el botón de eliminar está presente
    expect(find.byIcon(Icons.delete), findsOneWidget);

    // Presionar el botón de eliminar
    await tester.tap(find.byIcon(Icons.delete));
    expect(deleteCalled, isTrue);
  });

  testWidgets('SessionCard no muestra botón de eliminar si onDelete es null', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: appTheme,
        home: Scaffold(body: SessionCard(session: testSession)),
      ),
    );

    // No debe haber botón de eliminar
    expect(find.byIcon(Icons.delete), findsNothing);
  });
}
