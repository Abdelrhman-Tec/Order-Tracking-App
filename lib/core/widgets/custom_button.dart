import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final TextStyle? textStyle;
  final double? height;
  final IconData? icon;
  final double borderRadius;
  final Gradient? gradient;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.icon,
    this.borderRadius = 12,
    this.gradient,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final defaultTextColor = textColor ?? Colors.white;

    Widget buttonChild = _buildButtonChild(defaultTextColor);

    // زر Outline
    if (isOutlined) {
      return GestureDetector(
        onTap: isLoading ? null : onPressed,
        child: Container(
          width: width ?? double.infinity,
          height: height ?? 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: backgroundColor ?? Theme.of(context).primaryColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: buttonChild,
        ),
      );
    }

    // زر Container أو Gradient
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: gradient == null
              ? backgroundColor ?? Theme.of(context).primaryColor
              : null,
          gradient: gradient,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: buttonChild,
      ),
    );
  }

  Widget _buildButtonChild(Color color) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Text(text, style: textStyle),
        ],
      );
    }

    return Text(
      text,
      style: textStyle ?? TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color),
    );
  }
}
