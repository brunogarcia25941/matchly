import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Cores Principais
  static const Color background = Color(0xFF0F0F0F); // Preto OLED / Quase puro
  static const Color surface = Color(0xFF1E1E1E);    // Cinza escuro para Cartões
  static const Color surfaceLight = Color(0xFF2A2A2A); // Superfícies secundárias
  
  // Destaques (Matchly Signature)
  static const Color primaryOrange = Color(0xFFFF5F00); // Laranja Vibrante
  static const Color primaryOrangeHover = Color(0xFFE05300);

  // Texto
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA0A0A0);
  static const Color textMuted = Color(0xFF666666);

  // Estados de Jogo (Ao vivo, Terminado, etc)
  static const Color liveRed = Color(0xFFFF3B30); // Vermelho chamativo para o tempo real
  static const Color greenSuccess = Color(0xFF34C759);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primaryOrange,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryOrange,
        surface: AppColors.surface,
      ),
      // Tipografia Inter para o corpo
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        bodyMedium: const TextStyle(color: AppColors.textPrimary),
        bodySmall: const TextStyle(color: AppColors.textSecondary),
      ),
      useMaterial3: true,
    );
  }
}