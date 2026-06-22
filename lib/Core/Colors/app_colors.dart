import 'package:flutter/material.dart';

class AppColors {
  static bool isDark = false;

  // الألوان الأساسية
  static Color get primary => const Color(0xFF1A3D6D);
  static Color get accent => const Color(0xFFF2A916);
  static Color get scaffoldBackground => isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FB);
  static Color get cardBackground => isDark ? const Color(0xFF1E1E1E) : Colors.white;
  static Color get success => const Color(0xFF27AE60);

  static Color get inputFill => isDark ? const Color(0xFFF4F7FA) : const Color(0xFFF4F7FA);

  // ألوان النصوص
  static Color get textMain => isDark ? Colors.white : const Color(0xFF1A3D6D);
  static Color get textSecondary => isDark ? Colors.grey[400]! : Colors.grey.shade600;

  // ألوان البطاقات والإشعارات
  static Color get cardShadow => isDark ? Colors.black.withOpacity(0.5) : const Color(0x0A000000);
  static Color get iconBackground => isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF1F4F8);

  // الألوان الخاصة بالحالات
  static Color get greenStatus => const Color(0xFF4CAF50);
  static Color get greenBackground => const Color(0xFFE8F5E9);
  static Color get blueStatus => primary;
  static Color get blueBackground => const Color(0xFFE3F2FD);
  static Color get redStatus => const Color(0xFFE53935);
  static Color get redBackground => const Color(0xFFFFEBEE);
  static Color get orangeStatus => accent;
  static Color get orangeBackground => const Color(0xFFFFF8E1);
  static Color get urgentRed => const Color(0xFFE53935);
  static Color get urgentRedBg => const Color(0xFFFFE5E5);
  static Color get newBlue => const Color(0xFF2196F3);
  static Color get newBlueBg => const Color(0xFFE3F2FD);
}