import 'package:flutter/material.dart';

void showCustomSnackbar({
  required BuildContext context,
  required String message,
  Color backgroundColor = Colors.black,
  Color textColor = Colors.white,
  Duration duration = const Duration(seconds: 3),
  SnackBarBehavior behavior = SnackBarBehavior.floating,
}) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
    ),
    backgroundColor: backgroundColor,
    behavior: behavior,
    duration: duration,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
