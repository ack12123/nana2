import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        _seedColor = seedColor {
    _loadFromPrefs(); // 在初始化时加载持久化数据
  }

  ThemeMode get themeMode => _themeMode;
  Color get seedColor => _seedColor;

  ThemeData get lightTheme => getLightTheme(_seedColor);
  ThemeData get darkTheme => getDarkTheme(_seedColor);

  // 设置主题模式并持久化
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _saveToPrefs(); // 保存到本地存储
    notifyListeners();
  }

  // 设置种子颜色并持久化
  void setSeedColor(Color color) {
    _seedColor = color;
    _saveToPrefs(); // 保存到本地存储
    notifyListeners();
  }

  // 将设置保存到 SharedPreferences
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('themeMode', _themeMode.index);
    prefs.setInt('seedColor', _seedColor.value);
  }

  // 从 SharedPreferences 加载设置
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = ThemeMode.values[prefs.getInt('themeMode') ?? ThemeMode.system.index];
    _seedColor = Color(prefs.getInt('seedColor') ?? Colors.blue.value);
    notifyListeners();
  }
}
