import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    this.value,
    this.label,
    this.onChanged,
    this.borderRadius,
    this.prefixIcon,
    this.keyboardType,
    this.noOfLines,
    this.textCapitalization,
  }) : super(key: key);

  final Function(String)? onChanged; // Notice the variable type
  final String? value;
  final String? label;
  final BorderRadius? borderRadius;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final int? noOfLines;
  final TextCapitalization? textCapitalization;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: noOfLines,
      maxLines: noOfLines,
      initialValue: value,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            decorationColor: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
      cursorColor: Theme.of(context).colorScheme.onSurface,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        hintText: label ?? 'Input',
        hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
            ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
          borderRadius: borderRadius ?? BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
          borderRadius: borderRadius ?? BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.04),
      ),
      onChanged: onChanged,
      textCapitalization: textCapitalization ?? TextCapitalization.words,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.done,
    );
  }
}
