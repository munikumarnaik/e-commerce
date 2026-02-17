import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';

class AdminFormField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final int maxLines;
  final bool required;

  const AdminFormField({
    super.key,
    required this.label,
    this.hint,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.md),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: required ? '$label *' : label,
          hintText: hint,
        ),
      ),
    );
  }
}

class AdminDropdownField<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final bool required;

  const AdminDropdownField({
    super.key,
    required this.label,
    this.value,
    required this.items,
    this.onChanged,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.md),
      child: DropdownButtonFormField<T>(
        value: value,
        items: items,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: required ? '$label *' : label,
        ),
        validator: required
            ? (value) => value == null ? 'Please select $label' : null
            : null,
      ),
    );
  }
}
