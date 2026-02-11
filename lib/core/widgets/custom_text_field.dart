import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    this.controller,
    this.focusNode,
    this.initialValue,
    this.label,
    this.hint,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.onFieldSubmitted,
    this.prefix,
    this.prefixIcon,
    this.suffix,
    this.suffixIcon,
    this.isPassword = false,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.filled = false,
    this.fillColor,
    this.style,
    this.hintStyle,
    this.labelStyle,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
    this.cursorColor,
    this.contentPadding,
    this.borderRadius = 12,
    this.autovalidateMode,
    this.capitalization = TextCapitalization.none,
    this.ontap,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? initialValue;
  final Function()? ontap;

  final String? label;
  final String? hint;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;

  final Widget? prefix;
  final IconData? prefixIcon;
  final Widget? suffix;
  final Widget? suffixIcon;

  final bool isPassword;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;

  final int maxLines;
  final int? minLines;
  final int? maxLength;

  final bool filled;
  final Color? fillColor;

  final TextStyle? style;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;

  final List<TextInputFormatter>? inputFormatters;

  final TextAlign textAlign;
  final Color? cursorColor;
  final EdgeInsetsGeometry? contentPadding;

  final double borderRadius;
  final AutovalidateMode? autovalidateMode;
  final TextCapitalization capitalization;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: widget.ontap,
      controller: widget.controller,
      focusNode: widget.focusNode,
      initialValue: widget.controller == null ? widget.initialValue : null,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      obscureText: _obscureText,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      style: widget.style,
      inputFormatters: widget.inputFormatters,
      textAlign: widget.textAlign,
      cursorColor: widget.cursorColor,
      autovalidateMode: widget.autovalidateMode,
      textCapitalization: widget.capitalization,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: widget.labelStyle,
        hintText: widget.hint,
        hintStyle: widget.hintStyle,
        prefix: widget.prefix,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        suffix: widget.suffix,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : widget.suffixIcon,
        filled: widget.filled,
        fillColor: widget.fillColor,
        contentPadding:
            widget.contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: _border(Colors.grey),
        enabledBorder: _border(Colors.grey),
        focusedBorder: _border(Colors.blue),
        errorBorder: _border(Colors.red),
        focusedErrorBorder: _border(Colors.red),
      ),
    );
  }
}
