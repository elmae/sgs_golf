import 'package:flutter/material.dart';

class DistanceInputWidget extends StatelessWidget {
  final double? value;
  final ValueChanged<double> onChanged;

  const DistanceInputWidget({super.key, this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: value?.toString() ?? '');
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Distancia (m)',
        border: OutlineInputBorder(),
      ),
      onChanged: (val) {
        final parsed = double.tryParse(val);
        if (parsed != null) {
          onChanged(parsed);
        }
      },
    );
  }
}
