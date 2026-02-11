import 'package:flutter/material.dart';

abstract class AppColors {
  AppColors._();

  // ===== Primary Colors (Logo) =====
  static const Color primaryBlue = Color(0xFF0D1B3F); // Navy text
  static const Color primaryOrange = Color(0xFFF57C00); // App + box

  // ===== Accent Colors =====
  static const Color accentRed = Color(0xFFE53935); // Location pin
  static const Color accentBlue = Color(0xFF1E88E5); // Route / map
  static const Color accentGreen = Color(0xFF43A047); // Route / map

  // ===== Neutral Colors =====
  static const Color white = Colors.white;
  static const Color black = Color(0xFF121212);

  // ===== Greys =====
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
}
