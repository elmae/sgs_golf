// ignore_for_file: directives_ordering

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sgs_golf/features/auth/login_screen.dart';
import 'package:sgs_golf/features/auth/register_screen.dart';
import 'package:sgs_golf/features/auth/providers/auth_provider.dart';
import 'package:sgs_golf/shared/widgets/custom_button.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthProvider extends Mock implements AuthProvider {}

void main() {
  group('LoginScreen', () {
    testWidgets('renderiza campos de correo y contraseña y botón de login', (
      tester,
    ) async {
      final mockProvider = MockAuthProvider();
      when(() => mockProvider.status).thenReturn(AuthStatus.unauthenticated);
      when(() => mockProvider.autenticado).thenReturn(false);
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>.value(
          value: mockProvider,
          child: const MaterialApp(home: LoginScreen()),
        ),
      );
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Correo electrónico'), findsOneWidget);
      expect(find.text('Contraseña'), findsOneWidget);
      expect(find.byType(CustomButton), findsOneWidget);
      expect(
        find.textContaining('Iniciar sesión', findRichText: true),
        findsOneWidget,
      );
    });

    testWidgets('permite escribir en los campos de correo y contraseña', (
      tester,
    ) async {
      final mockProvider = MockAuthProvider();
      when(() => mockProvider.status).thenReturn(AuthStatus.unauthenticated);
      when(() => mockProvider.autenticado).thenReturn(false);
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>.value(
          value: mockProvider,
          child: const MaterialApp(home: LoginScreen()),
        ),
      );
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'test@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'Password123');
      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('Password123'), findsOneWidget);
    });

    testWidgets('muestra mensaje de error si los campos están vacíos', (
      tester,
    ) async {
      final mockProvider = MockAuthProvider();
      when(() => mockProvider.status).thenReturn(AuthStatus.unauthenticated);
      when(() => mockProvider.autenticado).thenReturn(false);
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>.value(
          value: mockProvider,
          child: const MaterialApp(home: LoginScreen()),
        ),
      );
      await tester.tap(find.byType(CustomButton));
      await tester.pump();
      expect(
        find.textContaining('obligatorio', findRichText: true),
        findsWidgets,
      );
    });

    testWidgets(
      'muestra mensaje de error si el correo tiene formato inválido',
      (tester) async {
        final mockProvider = MockAuthProvider();
        when(() => mockProvider.status).thenReturn(AuthStatus.unauthenticated);
        when(() => mockProvider.autenticado).thenReturn(false);
        await tester.pumpWidget(
          ChangeNotifierProvider<AuthProvider>.value(
            value: mockProvider,
            child: const MaterialApp(home: LoginScreen()),
          ),
        );
        await tester.enterText(
          find.byType(TextFormField).at(0),
          'correo-invalido',
        );
        await tester.enterText(find.byType(TextFormField).at(1), 'Password123');
        await tester.tap(find.byType(CustomButton));
        await tester.pump();
        expect(
          find.textContaining('Formato de correo inválido', findRichText: true),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'muestra mensaje de error del provider (ej: Usuario no encontrado)',
      (tester) async {
        final mockProvider = MockAuthProvider();
        when(() => mockProvider.status).thenReturn(AuthStatus.error);
        when(() => mockProvider.autenticado).thenReturn(false);
        when(
          () => mockProvider.errorMessage,
        ).thenReturn('Usuario no encontrado');
        await tester.pumpWidget(
          ChangeNotifierProvider<AuthProvider>.value(
            value: mockProvider,
            child: const MaterialApp(home: LoginScreen()),
          ),
        );
        expect(
          find.textContaining('Usuario no encontrado', findRichText: true),
          findsOneWidget,
        );
      },
    );

    testWidgets('llama a login en AuthProvider al presionar el botón', (
      tester,
    ) async {
      final mockProvider = MockAuthProvider();
      when(() => mockProvider.login(any(), any())).thenAnswer((_) async {});
      when(() => mockProvider.status).thenReturn(AuthStatus.unauthenticated);
      when(() => mockProvider.autenticado).thenReturn(false);
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>.value(
          value: mockProvider,
          child: const MaterialApp(home: LoginScreen()),
        ),
      );
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'test@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'Password123');
      await tester.tap(find.byType(CustomButton));
      await tester.pump();
      verify(
        () => mockProvider.login('test@example.com', 'Password123'),
      ).called(1);
    });

    testWidgets('navega a la pantalla de registro al presionar el enlace', (
      tester,
    ) async {
      final mockProvider = MockAuthProvider();
      when(() => mockProvider.status).thenReturn(AuthStatus.unauthenticated);
      when(() => mockProvider.autenticado).thenReturn(false);
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>.value(
          value: mockProvider,
          child: const MaterialApp(home: LoginScreen()),
        ),
      );
      await tester.tap(find.widgetWithText(TextButton, 'Regístrate'));
      await tester.pumpAndSettle();
      expect(find.byType(RegisterScreen), findsOneWidget);
    });
  });
}
