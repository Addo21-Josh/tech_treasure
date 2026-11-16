import 'package:flutter/material.dart';
import '../constants/app_enums.dart';

/// Semantic color palette for the "Digital Treasure Chest" design system.
abstract class AppColors {
  // Brand Accents
  static const Color treasureGold = Color(0xFFF59E0B); // Amber 500
  static const Color treasureGoldDark = Color(0xFFD97706); // Amber 600
  static const Color treasureGoldLight = Color(0xFFFDE68A); // Amber 200
  static const Color treasureGoldContainerDark = Color(0xFF78350F); // Amber 900
  static const Color treasureGoldContainerLight = Color(
    0xFFFEF3C7,
  ); // Amber 100

  // Dark Mode Surfaces (Primary)
  static const Color darkBackground = Color(0xFF0F172A); // Slate 900
  static const Color darkCard = Color(0xFF1E293B); // Slate 800
  static const Color darkElevated = Color(0xFF334155); // Slate 700
  static const Color darkBorder = Color(0xFF334155); // Slate 700
  static const Color darkTextPrimary = Color(0xFFF8FAFC); // Slate 50
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Slate 400
  static const Color darkTextMuted = Color(0xFF64748B); // Slate 500

  // Light Mode Surfaces
  static const Color lightBackground = Color(0xFFF8FAFC); // Slate 50
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightElevated = Color(0xFFF1F5F9); // Slate 100
  static const Color lightBorder = Color(0xFFE2E8F0); // Slate 200
  static const Color lightTextPrimary = Color(0xFF0F172A); // Slate 900
  static const Color lightTextSecondary = Color(0xFF475569); // Slate 600
  static const Color lightTextMuted = Color(0xFF94A3B8); // Slate 400

  // Semantic Status Colors
  static const Color accentGold = treasureGold;
  static const Color accentCyan = Color(0xFF38BDF8);
  static const Color accentSuccess = Color(0xFF4ADE80);
  static const Color accentDanger = Color(0xFFF87171);
  static const Color darkSurface = darkCard;
  static const Color darkSurfaceElevated = darkElevated;

  static Color statusColor(TreasureStatus status) => switch (status) {
    TreasureStatus.idea => const Color(0xFFFBBF24), // Amber
    TreasureStatus.researching => const Color(0xFF38BDF8), // Sky Blue
    TreasureStatus.testing => const Color(0xFFC084FC), // Purple
    TreasureStatus.verified => const Color(0xFF4ADE80), // Emerald Green
    TreasureStatus.readyToCreate => const Color(0xFF818CF8), // Indigo
    TreasureStatus.scripted => const Color(0xFFFB923C), // Orange
    TreasureStatus.recorded => const Color(0xFF60A5FA), // Blue
    TreasureStatus.edited => const Color(0xFFA5B4FC), // Light Indigo
    TreasureStatus.published => const Color(0xFF34D399), // Mint Green
  };

  static Color statusBackgroundColor(
    TreasureStatus status, {
    bool isDark = true,
  }) {
    if (isDark) {
      return switch (status) {
        TreasureStatus.idea => const Color(0xFF451A03),
        TreasureStatus.researching => const Color(0xFF082F49),
        TreasureStatus.testing => const Color(0xFF3B0764),
        TreasureStatus.verified => const Color(0xFF052E16),
        TreasureStatus.readyToCreate => const Color(0xFF1E1B4B),
        TreasureStatus.scripted => const Color(0xFF431407),
        TreasureStatus.recorded => const Color(0xFF172554),
        TreasureStatus.edited => const Color(0xFF312E81),
        TreasureStatus.published => const Color(0xFF064E3B),
      };
    } else {
      return switch (status) {
        TreasureStatus.idea => const Color(0xFFFEF3C7),
        TreasureStatus.researching => const Color(0xFFE0F2FE),
        TreasureStatus.testing => const Color(0xFFF3E8FF),
        TreasureStatus.verified => const Color(0xFFDCFCE7),
        TreasureStatus.readyToCreate => const Color(0xFFE0E7FF),
        TreasureStatus.scripted => const Color(0xFFFFEDD5),
        TreasureStatus.recorded => const Color(0xFFDBEAFE),
        TreasureStatus.edited => const Color(0xFFEEF2FF),
        TreasureStatus.published => const Color(0xFFD1FAE5),
      };
    }
  }
}
