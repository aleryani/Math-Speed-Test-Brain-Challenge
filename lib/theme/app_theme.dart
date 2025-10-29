import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _primary = Color(0xFF6750A4);
  static const _secondary = Color(0xFF7D5260);
  static const _backgroundLight = Color(0xFFFAFAFD);
  static const _backgroundTint = Color(0xFFFDF7FF);
  static const _success = Color(0xFF2E7D32);
  static const _error = Color(0xFFC62828);

  static ThemeData light() {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.light,
    );
    final colorScheme = baseScheme.copyWith(
      primary: _primary,
      secondary: const Color(0xFFE25D82),
      tertiary: const Color(0xFF3EB7B7),
      surface: _backgroundLight,
      surfaceTint: _primary,
      background: _backgroundTint,
      onSurface: const Color(0xFF1A1C1E),
    );
    return _baseTheme(colorScheme).copyWith(
      scaffoldBackgroundColor: _backgroundTint,
      colorScheme: colorScheme,
      extensions: <ThemeExtension<dynamic>>[
        FeedbackColors(success: _success, error: _error),
        SurfaceGradients(
          homeBackground: const [
            Color(0xFFFFF1F4),
            Color(0xFFE7F6FF),
            Color(0xFFEFFAE3),
          ],
          gameBackground: const [
            Color(0xFFFBE7FF),
            Color(0xFFE1F5FE),
          ],
          cardHighlight: const [
            Color(0xFFFFF8E1),
            Color(0xFFE3F2FD),
          ],
        ),
      ],
    );
  }

  static ThemeData dark() {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.dark,
    );
    final colorScheme = baseScheme.copyWith(
      primary: _primary,
      secondary: const Color(0xFFEF7DA9),
      tertiary: const Color(0xFF58D0C3),
      surface: const Color(0xFF1F1A2B),
      background: const Color(0xFF181222),
    );
    return _baseTheme(colorScheme).copyWith(
      colorScheme: colorScheme,
      extensions: <ThemeExtension<dynamic>>[
        FeedbackColors(success: _success, error: _error),
        SurfaceGradients(
          homeBackground: const [
            Color(0xFF2B1F44),
            Color(0xFF1E2A4A),
          ],
          gameBackground: const [
            Color(0xFF2E1F46),
            Color(0xFF12374A),
          ],
          cardHighlight: const [
            Color(0xFF2A2B4D),
            Color(0xFF123D52),
          ],
        ),
      ],
    );
  }

  static ThemeData _baseTheme(ColorScheme scheme) {
    final textTheme = GoogleFonts.poppinsTextTheme();
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: textTheme.copyWith(
        headlineMedium: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
        titleLarge: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          minimumSize: const Size.fromHeight(56),
          elevation: 0,
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.4),
        ),
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 0,
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

class SurfaceGradients extends ThemeExtension<SurfaceGradients> {
  const SurfaceGradients({
    required this.homeBackground,
    required this.gameBackground,
    required this.cardHighlight,
  });

  final List<Color> homeBackground;
  final List<Color> gameBackground;
  final List<Color> cardHighlight;

  @override
  ThemeExtension<SurfaceGradients> lerp(
    covariant ThemeExtension<SurfaceGradients>? other,
    double t,
  ) {
    if (other is! SurfaceGradients) {
      return this;
    }
    return SurfaceGradients(
      homeBackground: _lerpColors(homeBackground, other.homeBackground, t),
      gameBackground: _lerpColors(gameBackground, other.gameBackground, t),
      cardHighlight: _lerpColors(cardHighlight, other.cardHighlight, t),
    );
  }

  @override
  SurfaceGradients copyWith({
    List<Color>? homeBackground,
    List<Color>? gameBackground,
    List<Color>? cardHighlight,
  }) {
    return SurfaceGradients(
      homeBackground: homeBackground ?? this.homeBackground,
      gameBackground: gameBackground ?? this.gameBackground,
      cardHighlight: cardHighlight ?? this.cardHighlight,
    );
  }

  static List<Color> _lerpColors(List<Color> a, List<Color> b, double t) {
    final maxLength = a.length > b.length ? a.length : b.length;
    return List<Color>.generate(maxLength, (index) {
      final from = a[index % a.length];
      final to = b[index % b.length];
      return Color.lerp(from, to, t) ?? from;
    });
  }
}
