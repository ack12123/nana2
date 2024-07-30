import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'theme_config.dart'; // 导入深色模式主题配置
import 'main.dart';
import 'kaixin.dart';
import 'sanmeng.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
      theme: lightTheme, // 使用亮色主题
      darkTheme: darkTheme, // 使用深色主题
      themeMode: ThemeMode.system, // 默认跟随系统设置主题
      home: const MyHomePage(),
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
              color: Theme.of(context).primaryColor,
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
              // Handle settings tap
            },
          ),
        ],
      ),
    );
  }
}