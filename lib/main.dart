import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:convert';
import 'audio_manager.dart';
import 'custom_drawer.dart';
import 'theme_config.dart'; // 导入深色模式主题配置

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final AudioManager _audioManager = AudioManager();
  final TextEditingController _searchController = TextEditingController();
  List<String> _lostStrengthFiles = [];
  List<String> _regainedStrengthFiles = [];
  List<String> _nanaSingingFiles = [];
  List<String> _aiNanaFiles = [];
  List<String> _heroFiles = [];
  List<String> _betaMusicFiles = [];
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadAudioFiles();
  }

  Future<void> _loadAudioFiles() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final lostStrengthFiles = manifestMap.keys
        .where((String key) => key.startsWith('assets/audio/失去了力气和手段/'))
        .map((e) => e.replaceFirst('assets/audio/', ''))
        .toList();
    final regainedStrengthFiles = manifestMap.keys
        .where((String key) => key.startsWith('assets/audio/恢复了力气和手段/'))
        .map((e) => e.replaceFirst('assets/audio/', ''))
        .toList();
    final nanaSingingFiles = manifestMap.keys
        .where((String key) => key.startsWith('assets/audio/来自娜娜的吟唱/'))
        .map((e) => e.replaceFirst('assets/audio/', ''))
        .toList();
    final aiNanaFiles = manifestMap.keys
        .where((String key) => key.startsWith('assets/audio/AI处理娜娜/'))
        .map((e) => e.replaceFirst('assets/audio/', ''))
        .toList();
    final heroFiles = manifestMap.keys
        .where((String key) => key.startsWith('assets/audio/王者全英雄/'))
        .map((e) => e.replaceFirst('assets/audio/', ''))
        .toList();
    final betaMusicFiles = manifestMap.keys
        .where((String key) => key.startsWith('assets/audio/贝塔系列音乐/'))
        .map((e) => e.replaceFirst('assets/audio/', ''))
        .toList();

    setState(() {
      _lostStrengthFiles = lostStrengthFiles;
      _regainedStrengthFiles = regainedStrengthFiles;
      _nanaSingingFiles = nanaSingingFiles;
      _aiNanaFiles = aiNanaFiles;
      _heroFiles = heroFiles;
      _betaMusicFiles = betaMusicFiles;
    });
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return ButtonTheme(
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
        ),
      ),
    );
  }

  Widget _buildAudioList(List<String> audioFiles) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8.0, // 设置按钮之间的水平间距
        runSpacing: 8.0, // 设置按钮之间的垂直间距
        children: audioFiles.map((audioFile) {
          String fileName = audioFile.split('/').last.split('.').first; // 获取文件名，不带路径和扩展名
          return _buildButton(
            fileName,
                () {
              _audioManager.playAudio(audioFile);
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMorePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(context, '来自娜娜的吟唱', _nanaSingingFiles),
          _buildSection(context, 'AI处理娜娜', _aiNanaFiles),
          _buildSection(context, '王者全英雄', _heroFiles),
          _buildSection(context, '贝塔系列音乐', _betaMusicFiles),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<String> audioFiles) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0, // 设置按钮之间的水平间距
            runSpacing: 8.0, // 设置按钮之间的垂直间距
            children: audioFiles.map((audioFile) {
              String fileName = audioFile.split('/').last.split('.').first; // 获取文件名，不带路径和扩展名
              return _buildButton(
                fileName,
                    () {
                  _audioManager.playAudio(audioFile);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWideScreen = constraints.maxWidth > 600;

        return Scaffold(
          appBar: AppBar(
            title: Card(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: '输入你想搜索的内容',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          body: Row(
            children: [
              if (isWideScreen)
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                      _pageController.jumpToPage(index); // 更新页面
                    });
                  },
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('失去'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.music_note),
                      label: Text('恢复'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.more_horiz),
                      label: Text('更多'),
                    ),
                  ],
                ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (int index) {
                    setState(() {
                      _selectedIndex = index; // 更新底部导航栏选择
                    });
                  },
                  children: [
                    _buildAudioList(_lostStrengthFiles),
                    _buildAudioList(_regainedStrengthFiles),
                    _buildMorePage(),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: !isWideScreen
              ? NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
                _pageController.jumpToPage(index); // 更新页面
              });
            },
            destinations: const <NavigationDestination>[
              NavigationDestination(
                icon: Icon(Icons.home),
                label: '失去',
              ),
              NavigationDestination(
                icon: Icon(Icons.music_note),
                label: '恢复',
              ),
              NavigationDestination(
                icon: Icon(Icons.more_horiz),
                label: '更多',
              ),
            ],
          )
              : null,
          drawer: const CustomDrawer(), // 使用自定义抽屉
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _audioManager.stopAllAudio();
            },
            tooltip: '停止播放',
            child: const Icon(Icons.stop),
          ),
        );
      },
    );
  }
}
