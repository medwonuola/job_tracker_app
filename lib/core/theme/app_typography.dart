import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class ContextTypography {
  static final String fontFamily = GoogleFonts.manrope().fontFamily!;

  static final TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 48,
    fontWeight: FontWeight.w800,
    height: 1.1,
    letterSpacing: -2.5,
    color: ContextColors.textPrimary,
  );

  static final TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w800,
    height: 1.2,
    letterSpacing: -2.0,
    color: ContextColors.textPrimary,
  );

  static final TextStyle h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    height: 1.25,
    letterSpacing: -1.5,
    color: ContextColors.textPrimary,
  );

  static final TextStyle h4 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w800,
    height: 1.3,
    color: ContextColors.textPrimary,
  );

  static final TextStyle bodyLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: ContextColors.textSecondary,
  );

  static final TextStyle bodyMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: ContextColors.textSecondary,
  );

  static final TextStyle bodySm = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: ContextColors.textSecondary,
  );
}
