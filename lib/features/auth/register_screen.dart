// Cambios realizados para la tarea 2.4.3 PRD:
// - Mejora de la visibilidad y claridad de los mensajes de error del provider.
// - Ahora los errores se muestran en un Card con icono y texto amigable, cumpliendo la tarea 2.4.3 del PRD.
// - No se modificó la lógica del provider, solo la UI.
// - Documentación inline de los cambios.
 // Pantalla de Registro SGS Golf
// ignore_for_file: directives_ordering

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sgs_golf/shared/widgets/custom_button.dart';
import 'package:sgs_golf/features/auth/providers/auth_provider.dart';
import 'package:sgs_golf/core/navigation/app_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _validateAndSubmit(AuthProvider authProvider) async {
    setState(() {
      _nameError = null;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    bool isValid = true;

    // Validación de nombre
    if (name.isEmpty) {
      _nameError = 'El nombre es obligatorio';
      isValid = false;
    }

    // Validación de email
    if (email.isEmpty) {
      _emailError = 'El correo es obligatorio';
      isValid = false;
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _emailError = 'Formato de correo inválido';
      isValid = false;
    }

    // Validación de contraseña
    if (password.isEmpty) {
      _passwordError = 'La contraseña es obligatoria';
      isValid = false;
    } else if (password.length < 6) {
      _passwordError = 'Mínimo 6 caracteres';
      isValid = false;
    }

    // Validación de confirmación
    if (confirmPassword.isEmpty) {
      _confirmPasswordError = 'Confirma la contraseña';
      isValid = false;
    } else if (password != confirmPassword) {
      _confirmPasswordError = 'Las contraseñas no coinciden';
      isValid = false;
    }

    if (isValid) {
      await authProvider.register(name, email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Integración automática: Navega al dashboard si autenticado.
        if (authProvider.autenticado) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
          });
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Crear cuenta')),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Mensaje de error del provider (tarea 2.4.3 PRD)
                    if (authProvider.status == AuthStatus.error && authProvider.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          children: [
                            Card(
                              color: Colors.red[50],
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              child: ListTile(
                                leading: const Icon(Icons.error_outline, color: Colors.red),
                                title: const Text(
                                  'Ocurrió un problema:',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  authProvider.errorMessage!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    // Nombre
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nombre',
                        errorText: _nameError,
                        prefixIcon: const Icon(Icons.person),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Correo electrónico',
                        errorText: _emailError,
                        prefixIcon: const Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    // Contraseña
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        errorText: _passwordError,
                        prefixIcon: const Icon(Icons.lock),
                      ),
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    // Confirmar contraseña
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirmar contraseña',
                        errorText: _confirmPasswordError,
                        prefixIcon: const Icon(Icons.lock_outline),
                      ),
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 32),
                    // Indicador de carga y mensajes de error/autenticado integrados con AuthProvider.
                    if (authProvider.status == AuthStatus.loading)
                      const CircularProgressIndicator(),
                    // Solo mostrar el mensaje de error del provider una vez (Card principal)
                    if (authProvider.status == AuthStatus.authenticated)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          '¡Registro exitoso!',
                          style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold),
                        ),
                      ),
                    CustomButton(
                      label: 'Registrarse',
                      onPressed: () {
                        if (authProvider.status != AuthStatus.loading) {
                          _validateAndSubmit(authProvider);
                        }
                      },
                    ),
                    // Enlace para navegar a login
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/login');
                      },
                      child: const Text(
                        'Inicia sesión',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  
  }
