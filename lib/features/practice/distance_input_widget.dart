import 'package:flutter/material.dart';

class DistanceInputWidget extends StatefulWidget {
  final double? value;
  final ValueChanged<double> onChanged;

  const DistanceInputWidget({super.key, this.value, required this.onChanged});

  @override
  State<DistanceInputWidget> createState() => _DistanceInputWidgetState();
}

class _DistanceInputWidgetState extends State<DistanceInputWidget> {
  late TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value?.toString() ?? '');
  }

  @override
  void didUpdateWidget(covariant DistanceInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.text = widget.value?.toString() ?? '';
    }
  }

  void _onChanged(String val) {
    final parsed = double.tryParse(val);
    if (parsed == null) {
      setState(() {
        _errorText = 'Ingrese un número válido';
      });
      return;
    }
    if (parsed < 10 || parsed > 200) {
      setState(() {
        _errorText = 'Distancia fuera de rango (10-200)';
      });
      widget.onChanged(parsed); // aún así notifica para lógica externa
      return;
    }
    setState(() {
      _errorText = null;
    });
    widget.onChanged(parsed);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Distancia (m)',
        border: const OutlineInputBorder(),
        errorText: _errorText,
      ),
      onChanged: _onChanged,
    );
  }
}
