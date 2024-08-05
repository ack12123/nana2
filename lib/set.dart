import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_notifier.dart';

class SetPage extends StatelessWidget {
  const SetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('主题模式', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildThemeOption(context, '浅色模式', ThemeMode.light, themeNotifier),
            _buildThemeOption(context, '深色模式', ThemeMode.dark, themeNotifier),
            _buildThemeOption(context, '系统默认', ThemeMode.system, themeNotifier),
            const SizedBox(height: 20),
            const Text('颜色选择', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: [
                _buildColorOption(context, Colors.blue),
                _buildColorOption(context, Colors.cyan),
                _buildColorOption(context, Colors.pink),
                _buildColorOption(context, Colors.orange),
                _buildColorOption(context, Colors.green),
                _buildColorOption(context, Colors.purple),
                _buildColorOption(context, Colors.teal),
                _buildColorOption(context, Colors.yellow),
              ],
            ),
            const SizedBox(height: 20),
            const Text('哈哈哈', style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(BuildContext context, String title, ThemeMode mode, ThemeNotifier themeNotifier) {
    return ListTile(
      title: Text(title),
      leading: Radio<ThemeMode>(
        value: mode,
        groupValue: themeNotifier.themeMode,
        onChanged: (ThemeMode? value) {
          if (value != null) {
            themeNotifier.setThemeMode(value);
          }
        },
      ),
      tileColor: themeNotifier.themeMode == mode
          ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
          : null,
      onTap: () {
        themeNotifier.setThemeMode(mode);
      },
    );
  }

  Widget _buildColorOption(BuildContext context, Color color) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return GestureDetector(
      onTap: () => themeNotifier.setSeedColor(color),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: themeNotifier.seedColor == color
                ? Colors.black.withOpacity(0.5)
                : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }
}
