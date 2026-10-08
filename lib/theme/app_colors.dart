import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryDeep = Color(0xFF4338CA);
  static const Color primaryLight = Color(0xFFEEF2FF);

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF4338CA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color income = Color(0xFF10B981);
  static const Color incomeLight = Color(0xFFDCFCE7);

  static const Color expense = Color(0xFFEF4444);
  static const Color expenseLight = Color(0xFFFEE2E2);

  static const Color fixed = Color(0xFF8B5CF6);
  static const Color fixedLight = Color(0xFFEDE9FE);

  static const Color starGold = Color(0xFFF59E0B);
  static const Color starGoldLight = Color(0xFFFEF3C7);

  static const Color background = Color(0xFFF8FAFC);
  static const Color card = Colors.white;
  static const Color border = Color(0xFFE2E8F0);
  static const Color inputBackground = Color(0xFFF8FAFC);

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: const Color(0xFF4338CA).withValues(alpha: 0.08),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get fabShadow => [
        BoxShadow(
          color: const Color(0xFF6366F1).withValues(alpha: 0.35),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];
}
