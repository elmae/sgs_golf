import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sgs_golf/shared/utils/animation_utils.dart';

void main() {
  group('AnimationUtils', () {
    testWidgets('fadeInAnimation should animate opacity', (tester) async {
      final widget = AnimationUtils.fadeInAnimation(
        child: const SizedBox(key: Key('test-child')),
      );

      await tester.pumpWidget(MaterialApp(home: widget));

      // Verify initial state
      var opacity = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacity.opacity, 0.0);

      // Wait for animation halfway
      await tester.pump(const Duration(milliseconds: 150));
      opacity = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacity.opacity, greaterThan(0.0));
      expect(opacity.opacity, lessThan(1.0));

      // Wait for animation completion
      await tester.pump(const Duration(milliseconds: 150));
      opacity = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacity.opacity, 1.0);
    });

    testWidgets('slideInAnimation should animate translation', (tester) async {
      const offset = 20.0;
      final widget = AnimationUtils.slideInAnimation(
        child: const SizedBox(key: Key('test-child')),
      );

      await tester.pumpWidget(MaterialApp(home: widget));

      // Verify initial state
      var transform = tester.widget<Transform>(find.byType(Transform));
      expect(transform.transform.getTranslation().y, offset);

      // Wait for animation halfway
      await tester.pump(const Duration(milliseconds: 150));
      transform = tester.widget<Transform>(find.byType(Transform));
      expect(transform.transform.getTranslation().y, greaterThan(0.0));
      expect(transform.transform.getTranslation().y, lessThan(offset));

      // Wait for animation completion
      await tester.pump(const Duration(milliseconds: 150));
      transform = tester.widget<Transform>(find.byType(Transform));
      expect(transform.transform.getTranslation().y, 0.0);
    });

    testWidgets(
      'fadeSlideInAnimation should combine fade and slide animations',
      (tester) async {
        final widget = AnimationUtils.fadeSlideInAnimation(
          child: const SizedBox(key: Key('test-child')),
        );

        await tester.pumpWidget(MaterialApp(home: widget));

        // Verify presence of both animations
        expect(find.byType(Opacity), findsOneWidget);
        expect(find.byType(Transform), findsOneWidget);

        // Verify initial state
        var opacity = tester.widget<Opacity>(find.byType(Opacity));
        var transform = tester.widget<Transform>(find.byType(Transform));
        expect(opacity.opacity, 0.0);
        expect(transform.transform.getTranslation().y, 20.0);

        // Wait for animation completion
        await tester.pumpAndSettle();
        opacity = tester.widget<Opacity>(find.byType(Opacity));
        transform = tester.widget<Transform>(find.byType(Transform));
        expect(opacity.opacity, 1.0);
        expect(transform.transform.getTranslation().y, 0.0);
      },
    );

    testWidgets('scaleTapAnimation should respond to tap events', (
      tester,
    ) async {
      bool tapped = false;
      final widget = AnimationUtils.scaleTapAnimation(
        onTap: () => tapped = true,
        child: Center(
          child: Container(
            key: const Key('test-child'),
            width: 100,
            height: 100,
            color: Colors.blue,
          ),
        ),
      );

      await tester.pumpWidget(MaterialApp(home: widget));

      // Verify initial scale
      var scale = tester.widget<AnimatedScale>(find.byType(AnimatedScale));
      expect(scale.scale, 1.0);

      // Trigger tap down
      final gesture = await tester.createGesture();
      await gesture.down(tester.getCenter(find.byKey(const Key('test-child'))));
      await tester.pump();

      // Verify scale down
      scale = tester.widget<AnimatedScale>(find.byType(AnimatedScale));
      expect(scale.scale, 0.95);

      // Complete tap
      await gesture.up();
      await tester.pumpAndSettle();

      // Verify scale up and tap callback
      scale = tester.widget<AnimatedScale>(find.byType(AnimatedScale));
      expect(scale.scale, 1.0);
      expect(tapped, isTrue);
    });
  });
}
