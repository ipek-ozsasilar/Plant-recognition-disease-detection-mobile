import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:flutter/material.dart';

/// Ortak metin alanı — tema ile yuvarlatılmış çerçeve.
class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.validator,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool readOnly;
  final int maxLines;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      readOnly: readOnly,
      maxLines: maxLines,
      validator: validator,
      style: TextStyle(
        fontSize: TextSizesEnum.body.value,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        contentPadding: EdgeInsets.symmetric(
          horizontal: WidgetSizesEnum.cardRadius.value * 1.1,
          vertical: WidgetSizesEnum.divider.value * 10,
        ),
      ),
    );
  }
}
