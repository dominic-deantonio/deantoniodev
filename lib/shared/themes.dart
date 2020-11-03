import 'package:flutter/material.dart';

class Themes {
  static final ThemeData dark = ThemeData.dark().copyWith(
      appBarTheme: AppBarTheme(elevation: 0),
  );
  static final ThemeData light = ThemeData.light().copyWith(
    appBarTheme: AppBarTheme(elevation: 0),
  );
}
