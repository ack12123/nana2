import 'package:flutter/material.dart';

// 生成浅色主题的函数
ThemeData getLightTheme(Color seedColor) {
  final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.light,
  );

  return ThemeData(
    colorScheme: colorScheme,
    primaryColor: seedColor,
    secondaryHeaderColor: colorScheme.secondary,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        textStyle: const TextStyle(fontSize: 14),
      ),
    ),
  );
}

// 生成深色主题的函数
ThemeData getDarkTheme(Color seedColor) {
  final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.dark,
  );

  return ThemeData(
    colorScheme: colorScheme,
    primaryColor: seedColor,
    secondaryHeaderColor: colorScheme.secondary,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        textStyle: const TextStyle(fontSize: 14),
      ),
    ),
  );
}

// ThemeNotifier 类，用于管理主题模式和种子颜色
class ThemeNotifier with ChangeNotifier {
  ThemeMode _themeMode;
  Color _seedColor;

  ThemeNotifier({ThemeMode themeMode = ThemeMode.system, Color seedColor = Colors.blue})
      : _themeMode = themeMode,
        _seedColor = seedColor;

  ThemeMode get themeMode => _themeMode;
  Color get seedColor => _seedColor;

  ThemeData get lightTheme => getLightTheme(_seedColor);
  ThemeData get darkTheme => getDarkTheme(_seedColor);

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setSeedColor(Color color) {
    _seedColor = color;
    notifyListeners();
  }
}
