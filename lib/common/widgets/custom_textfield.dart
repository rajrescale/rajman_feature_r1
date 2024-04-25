import "package:flutter/material.dart";

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final String? prefixText;
  final bool obscureText;
  final String? labelText; // Added labelText
  final String? semanticLabel; // Added semanticLabel
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.obscureText = false,
    this.prefixText, // Initialize prefixText
    this.labelText, // Initialize labelText
    this.semanticLabel, // Initialize semanticLabel
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? hintText,
      hint: 'Enter your $hintText',
      child: TextFormField(
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
          labelText: hintText,
          prefixText: prefixText, // Use prefixText in decoration
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor, // Set border color here
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black38,
            ),
          ),
          fillColor: Theme.of(context).primaryColorDark,
          filled: true,
        ),
        validator: (val) {
          if (val == null || val.isEmpty) {
            return 'Enter your $hintText';
          }
          return null;
        },
        maxLines: maxLines,
      ),
    );
  }
}
