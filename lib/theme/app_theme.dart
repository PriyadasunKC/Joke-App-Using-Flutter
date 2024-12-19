import 'package:flutter/material.dart';

class AppTheme {
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF85A5FF),
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFF0F5FF),
    onPrimaryContainer: Color(0xFF69B1FF),
    secondary: Color(0xFFB37FEB),
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFF9F0FF),
    onSecondaryContainer: Color(0xFF85A5FF),
    tertiary: Color(0xFFF759AB),
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFFFF0F6),
    onTertiaryContainer: Color(0xFFB37FEB),
    error: Color(0xFFBA1A1A),
    onError: Colors.white,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    background: Color(0xFFF0F5FF),
    onBackground: Color(0xFF1C1B1F),
    surface: Color(0xFFF0F5FF),
    onSurface: Color(0xFF1C1B1F),
    surfaceVariant: Color(0xFFF0F5FF),
    onSurfaceVariant: Color(0xFF49454F),
    outline: Color(0xFF69B1FF),
    shadow: Color(0xFF000000),
  );

  static const lavenderSurfaces = {
    'card': Color(0xFFFFFFFF),
    'cardHover': Color(0xFFF0F5FF),
    'surface1': Color(0xFFF0F5FF),
    'surface2': Color(0xFFF9F0FF),
    'surface3': Color(0xFFFFFFFF),
  };

  static const lavenderOpacities = {
    'shadow1': Color(0x1485A5FF),
    'shadow2': Color(0x1CB37FEB),
    'divider': Color(0x1469B1FF),
  };

  static const cardGradients = {
    'primary': LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF85A5FF),
        Color(0xFF69B1FF),
      ],
      stops: [0.0, 1.0],
    ),
    'secondary': LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFB37FEB),
        Color(0xFF85A5FF),
      ],
      stops: [0.0, 1.0],
    ),
    'accent': LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFF759AB),
        Color(0xFFB37FEB),
      ],
      stops: [0.0, 1.0],
    ),
    'subtle': LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFFFFFFF),
        Color(0xFFF0F5FF),
      ],
      stops: [0.0, 1.0],
    ),
    'glass': LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xE6FFFFFF),
        Color(0xB3FFFFFF),
      ],
      stops: [0.0, 1.0],
    ),
    'soft': LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0x1A69B1FF),
        Color(0x1AB37FEB),
      ],
      stops: [0.0, 1.0],
    ),
  };

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: const Color(0x0D85A5FF),
          offset: const Offset(0, 4),
          blurRadius: 8,
          spreadRadius: -2,
        ),
        BoxShadow(
          color: const Color(0x14B37FEB),
          offset: const Offset(0, 8),
          blurRadius: 16,
          spreadRadius: -4,
        ),
      ];

  static List<BoxShadow> get cardHoverShadow => [
        BoxShadow(
          color: const Color(0x1485A5FF),
          offset: const Offset(0, 8),
          blurRadius: 16,
          spreadRadius: -2,
        ),
        BoxShadow(
          color: const Color(0x1FB37FEB),
          offset: const Offset(0, 12),
          blurRadius: 24,
          spreadRadius: -4,
        ),
      ];

  static const elevationOverlays = {
    'card': BoxShadow(
      color: Color(0x0A85A5FF),
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: -2,
    ),
    'cardHover': BoxShadow(
      color: Color(0x1469B1FF),
      offset: Offset(0, 8),
      blurRadius: 20,
      spreadRadius: -2,
    ),
  };

  static const stateOverlays = {
    'hover': Color(0x0A85A5FF),
    'focus': Color(0x1AB37FEB),
    'pressed': Color(0x1469B1FF),
    'dragged': Color(0x1FF759AB),
  };
}
