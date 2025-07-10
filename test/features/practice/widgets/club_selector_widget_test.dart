import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:sgs_golf/features/practice/widgets/club_selector_widget.dart';
import 'package:sgs_golf/data/models/golf_club.dart';

void main() {
  testWidgets('ClubSelectorWidget muestra todos los palos y permite seleccionar', (WidgetTester tester) async {
    GolfClubType? selected;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ClubSelectorWidget(
            selectedClub: null,
            onClubSelected: (club) => selected = club,
          ),
        ),
      ),
    );

    // Verifica que todos los nombres de palos estén presentes
    for (final name in ClubSelectorWidget.clubNames.values) {
      expect(find.text(name), findsOneWidget);
    }

    // Toca el primer club
    await tester.tap(find.text(ClubSelectorWidget.clubNames[GolfClubType.pw]!));
    await tester.pumpAndSettle();
    expect(selected, GolfClubType.pw);
  });
}
