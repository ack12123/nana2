import 'package:flutter/material.dart';

// 函数用于生成浅色主题
ThemeData getLightTheme(Color seedColor) {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
      secondary: seedColor.withOpacity(0.5), // 设置副颜色较浅
    ),
    brightness: Brightness.light,
    primaryColor: seedColor,
    secondaryHeaderColor: seedColor.withOpacity(0.5), // 直接设置副颜色
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

// 函数用于生成深色主题
ThemeData getDarkTheme(Color seedColor) {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
      secondary: seedColor.withOpacity(0.5), // 设置副颜色较浅
    ),
    brightness: Brightness.dark,
    primaryColor: seedColor,
    secondaryHeaderColor: seedColor.withOpacity(0.5), // 直接设置副颜色
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

// ThemeNotifier 用于管理主题模式和主题颜色
class ThemeNotifier with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system; // 默认跟随系统设置
  Color _seedColor = Colors.blue; // 默认颜色

  ThemeMode get themeMode => _themeMode;
  Color get seedColor => _seedColor;

  ThemeData get lightTheme => getLightTheme(_seedColor);
  ThemeData get darkTheme => getDarkTheme(_seedColor);

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners(); // 通知所有监听者
  }

  void setSeedColor(Color color) {
    _seedColor = color;
    notifyListeners(); // 通知所有监听者
  }
}
