import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'theme_notifier.dart'; // 导入深色模式主题配置
import 'main.dart';
import 'kaixin.dart';
import 'sanmeng.dart';
import 'set.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          locale: const Locale('zh', 'CN'), // 设置默认语言环境为 zh-Hans-CN
          supportedLocales: const [
            Locale('en', 'US'), // 添加其他支持的语言环境
            Locale('zh', 'CN'), // 添加中文简体
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          title: '语音包软件',
          theme: themeNotifier.lightTheme, // 使用主题通知器提供的浅色主题
          darkTheme: themeNotifier.darkTheme, // 使用主题通知器提供的深色主题
          themeMode: themeNotifier.themeMode, // 使用主题通知器提供的主题模式
          home: const MyHomePage(),
        );
      },
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).secondaryHeaderColor,
            ),
            child: Text(
              '选择你的英雄',
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('俄罗斯娜娜'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('开心姐'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const KaixinPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('三梦'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SanmengPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('设置'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SetPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}