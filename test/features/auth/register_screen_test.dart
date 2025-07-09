// ignore_for_file: directives_ordering

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sgs_golf/features/auth/register_screen.dart';
import 'package:sgs_golf/features/auth/login_screen.dart';
import 'package:sgs_golf/features/auth/providers/auth_provider.dart';
import 'package:sgs_golf/shared/widgets/custom_button.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthProvider extends Mock implements AuthProvider {}

void main() {
  group('RegisterScreen', () {
    testWidgets('renderiza campos de nombre, correo, contraseña y botón de registro', (tester) async {
        final mockProvider = MockAuthProvider();
        when(() => mockProvider.status).thenReturn(AuthStatus.unauthenticated);
        when(() => mockProvider.autenticado).thenReturn(false);
        await tester.pumpWidget(
          ChangeNotifierProvider<AuthProvider>.value(
            value: mockProvider,
            child: const MaterialApp(home: RegisterScreen()),
          ),
        );
        expect(find.byType(TextFormField), findsNWidgets(4));
        expect(find.text('Nombre'), findsOneWidget);
        expect(find.text('Correo electrónico'), findsOneWidget);
        expect(find.text('Contraseña'), findsOneWidget);
        expect(find.text('Confirmar contraseña'), findsOneWidget);
        expect(find.byType(CustomButton), findsOneWidget);
        expect(
          find.textContaining('Registrarse', findRichText: true),
          findsOneWidget,
        );
      },
    );

    testWidgets('permite escribir en los campos del formulario', (tester) async {
      final mockProvider = MockAuthProvider();
      when(() => mockProvider.status).thenReturn(AuthStatus.unauthenticated);
      when(() => mockProvider.autenticado).thenReturn(false);
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>.value(
          value: mockProvider,
          child: const MaterialApp(home: RegisterScreen()),
        ),
      );
      await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'test@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(2), 'Password123');
      await tester.enterText(find.byType(TextFormField).at(3), 'Password123');
      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('Password123'), findsNWidgets(2));
    });

    testWidgets('muestra mensaje de error si los campos están vacíos', (tester) async {
      final mockProvider = MockAuthProvider();
      when(() => mockProvider.status).thenReturn(AuthStatus.unauthenticated);
      when(() => mockProvider.autenticado).thenReturn(false);
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>.value(
          value: mockProvider,
          child: const MaterialApp(home: RegisterScreen()),
        ),
      );
      await tester.tap(find.byType(CustomButton));
      await tester.pump();
      expect(
        find.textContaining('obligatorio', findRichText: true),
        findsWidgets,
      );
    });

    testWidgets('muestra mensaje de error si el correo tiene formato inválido', (tester) async {
        final mockProvider = MockAuthProvider();
        when(() => mockProvider.status).thenReturn(AuthStatus.unauthenticated);
        when(() => mockProvider.autenticado).thenReturn(false);
        await tester.pumpWidget(
          ChangeNotifierProvider<AuthProvider>.value(
            value: mockProvider,
            child: const MaterialApp(home: RegisterScreen()),
          ),
        );
        await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
        await tester.enterText(
          find.byType(TextFormField).at(1),
          'correo-invalido',
        );
        await tester.enterText(find.byType(TextFormField).at(2), 'Password123');
        await tester.enterText(find.byType(TextFormField).at(3), 'Password123');
        await tester.tap(find.byType(CustomButton));
        await tester.pump();
        expect(
          find.textContaining('Formato de correo inválido', findRichText: true),
          findsOneWidget,
        );
      },
    );

    testWidgets('muestra mensaje de error si las contraseñas no coinciden', (tester) async {
      final mockProvider = MockAuthProvider();
      when(() => mockProvider.status).thenReturn(AuthStatus.unauthenticated);
      when(() => mockProvider.autenticado).thenReturn(false);
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>.value(
          value: mockProvider,
          child: const MaterialApp(home: RegisterScreen()),
        ),
      );
      await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'test@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(2), 'Password123');
      await tester.enterText(find.byType(TextFormField).at(3), 'OtraPassword');
      await tester.tap(find.byType(CustomButton));
      await tester.pump();
      expect(
        find.textContaining('no coinciden', findRichText: true),
        findsOneWidget,
      );
    });

    testWidgets('muestra mensaje de error del provider (ej: Correo ya registrado)', (tester) async {
        final mockProvider = MockAuthProvider();
        when(() => mockProvider.status).thenReturn(AuthStatus.error);
        when(() => mockProvider.autenticado).thenReturn(false);
        when(
          () => mockProvider.errorMessage,
        ).thenReturn('Correo ya registrado');
        await tester.pumpWidget(
          ChangeNotifierProvider<AuthProvider>.value(
            value: mockProvider,
            child: const MaterialApp(home: RegisterScreen()),
          ),
        );
        expect(
          find.textContaining('Correo ya registrado', findRichText: true),
          findsOneWidget,
        );
      },
    );

    testWidgets('llama a register en AuthProvider al presionar el botón', (tester) async {
      final mockProvider = MockAuthProvider();
      when(() => mockProvider.status).thenReturn(AuthStatus.unauthenticated);
      when(() => mockProvider.autenticado).thenReturn(false);
      when(
        () => mockProvider.register(any(), any(), any()),
      ).thenAnswer((_) async {});
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>.value(
          value: mockProvider,
          child: const MaterialApp(home: RegisterScreen()),
        ),
      );
      await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'test@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(2), 'Password123');
      await tester.enterText(find.byType(TextFormField).at(3), 'Password123');
      await tester.tap(find.byType(CustomButton));
      await tester.pump();
      verify(
        () => mockProvider.register(
          'Test User',
          'test@example.com',
          'Password123',
        ),
      ).called(1);
    });

    testWidgets('navega a la pantalla de login al presionar el enlace', (tester) async {
      final mockProvider = MockAuthProvider();
      when(() => mockProvider.status).thenReturn(AuthStatus.unauthenticated);
      when(() => mockProvider.autenticado).thenReturn(false);
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>.value(
          value: mockProvider,
          child: MaterialApp(
            home: const RegisterScreen(),
            routes: {'/login': (context) => const LoginScreen()},
          ),
        ),
      );
      // Busca el TextButton con el texto 'Inicia sesión' (el texto del botón de navegación real)
      await tester.tap(find.widgetWithText(TextButton, 'Inicia sesión'));
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);
    });
  });
}
