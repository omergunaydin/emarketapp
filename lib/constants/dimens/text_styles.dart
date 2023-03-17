import 'package:flutter/material.dart';

extension CustomStyles on TextTheme {
  TextStyle get promotionTextStyle {
    return const TextStyle(
      fontFamily: 'Hezaedrus',
      fontSize: 8.0,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
  }
}
