import 'package:flutter/material.dart';

enum MascotExpression { smiling, encouraging, exciting, neutral }

class MascotState {
  final MascotExpression expression;
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color mascotColor;
  final Color textColor;
  final TextAlign textAlign;
  final CrossAxisAlignment alignment;

  MascotState({
    required this.expression,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.mascotColor,
    required this.textColor,
    this.textAlign = TextAlign.center,
    this.alignment = CrossAxisAlignment.center,
  });
}
