import 'package:flutter/material.dart';
import 'arabic_fonts.dart';

/// Arapca ve Osmanlica metinler icin ortak widget.
/// Sadece metnin kendisi RTL olur; layout LTR kalir.
class ArabicText extends StatelessWidget {
  final String text;
  final bool rika;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final double height;
  final TextAlign align;
  final int? maxLines;

  const ArabicText(
    this.text, {
    super.key,
    this.rika = false,
    this.fontSize = 20,
    this.color = const Color(0xFF0A1F44),
    this.fontWeight = FontWeight.w500,
    this.height = 2.0,
    this.align = TextAlign.right,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final style = rika
        ? ArabicFonts.rikaStyle(
            fontSize: fontSize,
            color: color,
            fontWeight: fontWeight,
            height: height)
        : ArabicFonts.matbuStyle(
            fontSize: fontSize,
            color: color,
            fontWeight: fontWeight,
            height: height);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Text(
        text,
        style: style,
        textAlign: align,
        maxLines: maxLines,
        overflow: maxLines != null ? TextOverflow.ellipsis : null,
      ),
    );
  }
}
