import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/data/models/practice_session.dart';
import 'package:sgs_golf/data/models/shot.dart';
import 'package:sgs_golf/shared/widgets/session_card.dart';

void main() {
  group('SessionCard Animation Tests', () {
    final testSession = PracticeSession(
      date: DateTime.now(),
      duration: const Duration(minutes: 30),
      summary: 'Test session',
      shots: [
        Shot(
          clubType: GolfClubType.pw,
          distance: 200,
          timestamp: DateTime.now(),
        ),
      ],
    );

    testWidgets('SessionCard should animate when first rendered', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: SessionCard(session: testSession)),
        ),
      );

      // Initial state (start of animation)
      expect(find.byType(Opacity), findsWidgets);
      expect(find.byType(Transform), findsWidgets);

      // First frame should be at opacity 0
      var opacityWidgets = tester.widgetList<Opacity>(find.byType(Opacity));
      var firstOpacity = opacityWidgets.first;
      expect(firstOpacity.opacity, 0.0);

      // Animation in progress
      await tester.pump(const Duration(milliseconds: 150));
      opacityWidgets = tester.widgetList<Opacity>(find.byType(Opacity));
      firstOpacity = opacityWidgets.first;
      expect(firstOpacity.opacity, greaterThan(0.0));
      expect(firstOpacity.opacity, lessThan(1.0));

      // Animation complete
      await tester.pumpAndSettle();
      opacityWidgets = tester.widgetList<Opacity>(find.byType(Opacity));
      firstOpacity = opacityWidgets.first;
      expect(firstOpacity.opacity, 1.0);
    });

    testWidgets('SessionCard should scale on tap when onTap is provided', (
      tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SessionCard(session: testSession, onTap: () => tapped = true),
          ),
        ),
      );

      // Wait for initial animations to complete
      await tester.pumpAndSettle();

      // Find the GestureDetector
      final gesture = find.byType(GestureDetector);
      expect(gesture, findsWidgets);

      // Tap the card
      await tester.tap(gesture.first);
      await tester.pumpAndSettle();

      // Verify tap was handled
      expect(tapped, isTrue);
    });

    testWidgets('SessionCard should clean up animations when disposed', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: SessionCard(session: testSession)),
        ),
      );

      // Start animations
      await tester.pump();

      // Remove widget
      await tester.pumpWidget(const MaterialApp(home: Scaffold()));

      // Should not throw any errors when disposed
      await tester.pumpAndSettle();
    });
  });
}
