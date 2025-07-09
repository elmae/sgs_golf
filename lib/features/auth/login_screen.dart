// Cambios realizados para la tarea 2.4.3 PRD:
// - Mejora de la visibilidad y claridad de los mensajes de error del provider.
// - Ahora los errores se muestran en un Card con icono y texto amigable, cumpliendo la tarea 2.4.3 del PRD.
// - No se modificó la lógica del provider, solo la UI.
// - Documentación inline de los cambios.
// Pantalla de Login SGS Golf
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sgs_golf/core/navigation/app_router.dart';
import 'package:sgs_golf/core/theme/app_theme.dart';
import 'package:sgs_golf/features/auth/providers/auth_provider.dart';
import 'package:sgs_golf/features/auth/register_screen.dart';
import 'package:sgs_golf/shared/widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();

  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _validateAndSubmit(AuthProvider authProvider) async {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    bool isValid = true;

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
    }

    if (isValid) {
      await authProvider.login(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Integración automática: Navega al dashboard si autenticado.
        if (authProvider.autenticado) {
          // Usar addPostFrameCallback para evitar errores de contexto durante el build.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
          });
        }
        return Scaffold(
          backgroundColor: AppColors.grisSuave,
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Iniciar sesión',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: AppColors.azulProfundo,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 32),
                    // Indicador de carga y mensajes de error/autenticado integrados con AuthProvider.
                    if (authProvider.status == AuthStatus.loading)
                      const CircularProgressIndicator(),
                    if (authProvider.status == AuthStatus.error &&
                        authProvider.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Card(
                          color: Colors.red[50],
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            leading: const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                            ),
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
                      ),
                    if (authProvider.status == AuthStatus.authenticated)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          '¡Autenticado!',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Correo electrónico',
                        prefixIcon: const Icon(Icons.email),
                        errorText: _emailError,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.grisOscuro,
                          ),
                        ),
                      ),
                      style: const TextStyle(color: AppColors.grisOscuro),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: const Icon(Icons.lock),
                        errorText: _passwordError,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.grisOscuro,
                          ),
                        ),
                      ),
                      style: const TextStyle(color: AppColors.grisOscuro),
                    ),
                    const SizedBox(height: 32),
                    CustomButton(
                      label: 'Ingresar',
                      onPressed: () {
                        if (authProvider.status != AuthStatus.loading) {
                          _validateAndSubmit(authProvider);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '¿No tienes cuenta?',
                          style: TextStyle(
                            color: AppColors.grisOscuro,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Regístrate',
                            style: TextStyle(
                              color: AppColors.azulProfundo,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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
