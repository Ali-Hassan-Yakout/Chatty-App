import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary Colors
  static const primaryLight = Color(0xFFE3F2FD); // Light pastel blue
  static const primaryDark = Color(0xFF121212); // Modern dark background
  static const secondaryBlue = Color(0xFF42A5F5); // Bright secondary blue
  static const accentPurple = Color(0xFF9C27B0); // Vibrant purple accent

  // Neutrals & Text
  static const textPrimaryDark = Color(0xFFEDEDED); // Light text for dark theme
  static const textPrimaryLight =
      Color(0xFF212121); // Dark text for light theme
  static const neutralPurple = Color(0xFF7E57C2); // Muted purple for surfaces
  static const lightAccent = Color(0xFFCE93D8); // Soft purple
  static const linkBlue = Color(0xFF2196F3); // Standard link blue

  // Extras
  static const highlightPurple = Color(0xFFAB47BC); // Stronger purple highlight
  static const textFormFieldFill = Color(0xFF1E1E1E); // Dark fill for forms
  static const elevatedButton = Color(0xFF1976D2); // Strong blue button

  //Message bubble colors
  static const senderGradientLight = [
    Color(0xFF42A5F5),
    Color(0xFF1976D2),
  ]; // Blue gradient
  static const receiverGradientLight = [
    Color(0xFFCE93D8),
    Color(0xFFAB47BC),
  ]; // Purple gradient

  static const senderGradientDark = [
    Color(0xFF1565C0),
    Color(0xFF0D47A1),
  ];
  static const receiverGradientDark = [
    Color(0xFF8E24AA),
    Color(0xFF6A1B9A),
  ];
}
