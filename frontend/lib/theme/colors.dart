import 'package:flutter/material.dart';

class AppColors {
  // =========================
  // Pastel Palette
  // =========================

  static const Color background = Color(0xFFCDEDDD);

  static const Color surface = Color(0xFFC0E9ED);

  static const Color peach = Color(0xFFFCE6D3);

  static const Color rose = Color(0xFFFAD9D5);

  static const Color primary = Color(0xFFFBB7C7);

  // =========================
  // Text
  // =========================

  static const Color textPrimary = Color(0xFF2D3B40);

  static const Color textSecondary = Color(0xFF5D6D73);

  // =========================
  // Gradients
  // =========================

  static const List<Color> backgroundGradient = [
    Color(0xFFCDEDDD),
    Color(0xFFC0E9ED),
    Color(0xFFFCE6D3),
  ];

  static const List<Color> primaryGradient = [
    Color(0xFFFBB7C7),
    Color(0xFFFAD9D5),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFFCDEDDD),
    Color(0xFFC0E9ED),
  ];

  // =========================
  // Dashboard
  // =========================

  static const Color task = Color(0xFFFBB7C7);

  static const Color memory = Color(0xFFC0E9ED);

  static const Color chat = Color(0xFFFCE6D3);

  static const Color profile = Color(0xFFFAD9D5);

  // =========================
  // Glass
  // =========================

  static final Color glassBackground =
      Colors.white.withValues(alpha: .55);

  static final Color glassBorder =
      Colors.white.withValues(alpha: .45);

  static final Color shadow =
      Colors.black.withValues(alpha: .06);

  // Aliases
  static const Color pastelMint = background;
  static const Color pastelTeal = surface;
  static const Color pastelPeach = peach;
  static const Color pastelRose = rose;
  static const Color pastelPink = primary;

  // Dark Theme

  static const Color darkBackground = Color(0xFF17191F);

  static const Color darkSurface = Color(0xFF252A33);
}