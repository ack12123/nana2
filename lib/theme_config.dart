import 'package:flutter/material.dart';

// 浅色主题
final ColorScheme lightColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.blue,
  brightness: Brightness.light,
);

// 深色主题
final ColorScheme darkColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.blue,
  brightness: Brightness.dark,
);

// 浅色主题
final ThemeData lightTheme = ThemeData(
  colorScheme: lightColorScheme,
  brightness: Brightness.light,
  primaryColor: Colors.blueGrey,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16), // 按钮的内边距
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13), // 按钮的圆角
      ),
      textStyle: const TextStyle(fontSize: 14), // 设置文本样式，包括颜色和字体大小
    ),
  ),
  // 进一步定制按钮、文本等样式 (可选)
);

// 深色主题
final ThemeData darkTheme = ThemeData(
  colorScheme: darkColorScheme,
  brightness: Brightness.dark,
  primaryColor: Colors.blueGrey,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16), // 按钮的内边距
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13), // 按钮的圆角
      ),
      textStyle: const TextStyle(fontSize: 14), // 设置文本样式，包括颜色和字体大小
    ),
  ),
  // 进一步定制按钮、文本等样式 (可选)
);