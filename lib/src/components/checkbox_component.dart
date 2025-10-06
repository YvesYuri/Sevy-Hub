import 'package:flutter/material.dart';

class CheckboxComponent extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const CheckboxComponent({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.1,
      child: Checkbox(value: value, onChanged: onChanged),
    );
  }
}
