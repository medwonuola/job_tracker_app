import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'd3x_colors.dart';

class D3XTypography {
  static final String displayFontFamily = GoogleFonts.epilogue().fontFamily!;
  static final String bodyFontFamily = GoogleFonts.inter().fontFamily!;

  static final TextStyle headingH2 = TextStyle(
    fontFamily: displayFontFamily,
    fontSize: 60,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: D3XColors.textPrimary,
  );

  static final TextStyle headingH3 = TextStyle(
    fontFamily: displayFontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 1.25,
    color: D3XColors.textPrimary,
  );

  static final TextStyle bodyLg = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 1.75,
    color: D3XColors.textMuted,
  );

  static final TextStyle bodyMd = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: D3XColors.textMuted,
  );

  static final TextStyle bodySm = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: D3XColors.textMuted,
  );
}
