import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Widget para ingresar la distancia de un tiro de golf.
///
/// Incluye validación para asegurar que el valor es numérico y está en un rango razonable
/// para un tiro de golf (10-200 metros).
class DistanceInputWidget extends StatefulWidget {
  /// El valor inicial del campo
  final double? value;

  /// Función callback que se llama cuando cambia el valor
  final ValueChanged<double> onChanged;

  /// Rango mínimo aceptable (en metros)
  final double minRange;

  /// Rango máximo aceptable (en metros)
  final double maxRange;

  const DistanceInputWidget({
    super.key,
    this.value,
    required this.onChanged,
    this.minRange = 10.0,
    this.maxRange = 200.0,
  }) : assert(minRange < maxRange, 'El rango mínimo debe ser menor al máximo');

  @override
  State<DistanceInputWidget> createState() => _DistanceInputWidgetState();
}

class _DistanceInputWidgetState extends State<DistanceInputWidget> {
  late TextEditingController _controller;
  String? _errorText;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.value != null ? widget.value!.toStringAsFixed(1) : '',
    );
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
      // Validar cuando se pierde el foco
      if (!_isFocused && _controller.text.isNotEmpty) {
        _validateInput(_controller.text);
      }
    });
  }

  @override
  void didUpdateWidget(covariant DistanceInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != null) {
      _controller.text = widget.value!.toStringAsFixed(1);
      _errorText = null;
    }
  }

  bool _validateInput(String val) {
    // Si está vacío, no mostrar error pero tampoco es válido
    if (val.isEmpty) {
      setState(() {
        _errorText = null;
      });
      return false;
    }

    // Validar que sea un número
    final parsed = double.tryParse(val);
    if (parsed == null) {
      setState(() {
        _errorText = 'Ingrese un número válido';
      });
      return false;
    }

    // Validar el rango
    if (parsed < widget.minRange || parsed > widget.maxRange) {
      setState(() {
        _errorText =
            'Distancia fuera de rango (${widget.minRange.toInt()}-${widget.maxRange.toInt()} m)';
      });
      // Aún notificamos para lógica externa si se necesita
      widget.onChanged(parsed);
      return false;
    }

    // Todo está bien
    setState(() {
      _errorText = null;
    });
    widget.onChanged(parsed);
    return true;
  }

  void _onChanged(String val) {
    _validateInput(val);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.done,
          inputFormatters: [
            // Permitir solo números y un punto decimal
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
          ],
          decoration: InputDecoration(
            labelText: 'Distancia (m)',
            hintText: 'Ej: 85.5',
            border: const OutlineInputBorder(),
            errorText: _errorText,
            prefixIcon: const Icon(Icons.speed),
            suffixText: 'm',
            helperText:
                'Ingrese un valor entre ${widget.minRange.toInt()}-${widget.maxRange.toInt()} metros',
            filled: _isFocused,
            fillColor: _isFocused ? Color.fromRGBO(
              (theme.primaryColor.r * 255.0).round(),
              (theme.primaryColor.g * 255.0).round(),
              (theme.primaryColor.b * 255.0).round(),
              0.1,
            ) : null,
          ),
          onChanged: _onChanged,
          onSubmitted: (val) {
            if (_validateInput(val)) {
              // Si la validación es exitosa, podemos hacer algo adicional
              FocusScope.of(context).unfocus();
            }
          },
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _errorText!,
              style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
