import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _primary = Color(0xFF6750A4);
  static const _secondary = Color(0xFF7D5260);
  static const _backgroundLight = Color(0xFFFAFAFD);
  static const _success = Color(0xFF2E7D32);
  static const _error = Color(0xFFC62828);

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primary,
      primary: _primary,
      secondary: _secondary,
      surface: _backgroundLight,
      brightness: Brightness.light,
    );
    return _baseTheme(colorScheme).copyWith(
      scaffoldBackgroundColor: _backgroundLight,
      colorScheme: colorScheme,
      extensions: <ThemeExtension<dynamic>>[
        FeedbackColors(success: _success, error: _error),
      ],
    );
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.dark,
      primary: _primary,
      secondary: _secondary,
    );
    return _baseTheme(colorScheme).copyWith(
      colorScheme: colorScheme,
      extensions: <ThemeExtension<dynamic>>[
        FeedbackColors(success: _success, error: _error),
      ],
    );
  }

  static ThemeData _baseTheme(ColorScheme scheme) {
    final textTheme = GoogleFonts.poppinsTextTheme();
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          minimumSize: const Size.fromHeight(56),
          elevation: 1,
          textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 2,
        margin: EdgeInsets.zero,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

class FeedbackColors extends ThemeExtension<FeedbackColors> {
  const FeedbackColors({required this.success, required this.error});

  final Color success;
  final Color error;

  @override
  ThemeExtension<FeedbackColors> lerp(
      covariant ThemeExtension<FeedbackColors>? other, double t) {
    if (other is! FeedbackColors) {
      return this;
    }
    return FeedbackColors(
      success: Color.lerp(success, other.success, t) ?? success,
      error: Color.lerp(error, other.error, t) ?? error,
    );
  }

  @override
  FeedbackColors copyWith({Color? success, Color? error}) {
    return FeedbackColors(
      success: success ?? this.success,
      error: error ?? this.error,
    );
  }
}
