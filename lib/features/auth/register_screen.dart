// Pantalla de Registro SGS Golf
import 'package:flutter/material.dart';
import 'package:sgs_golf/shared/widgets/custom_button.dart';

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

  void _validateAndSubmit() {
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registro validado correctamente (solo UI)'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
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
                CustomButton(
                  label: 'Registrarse',
                  onPressed: _validateAndSubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
