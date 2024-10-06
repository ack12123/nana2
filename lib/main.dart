import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'file_downloader.dart';
import 'theme_notifier.dart';
import 'audio_manager.dart';
import 'custom_drawer.dart';
import 'dart:async';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          locale: const Locale('zh', 'CN'),
          supportedLocales: const [Locale('en', 'US'), Locale('zh', 'CN')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          title: '语音包软件',
          theme: themeNotifier.lightTheme,
          darkTheme: themeNotifier.darkTheme,
          themeMode: themeNotifier.themeMode,
          home: const MyHomePage(),
        );
      },
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
  List<String> _audioFiles = [];
  List<String> _filteredAudioFiles = [];
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadAudioFiles();
  }

  Future<void> _loadAudioFiles() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final manifestMap = json.decode(manifestContent) as Map<String, dynamic>;

    setState(() {
      _audioFiles = manifestMap.keys
          .where((key) => key.startsWith('assets/audio/娜娜/'))
          .map((e) => e.replaceFirst('assets/audio/', ''))
          .toList();
    });
  }

  void _filterAudioFiles(String query) {
    final lowerCaseQuery = query.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        // 如果搜索框内容为空，恢复到原来的显示
        _filteredAudioFiles = [];
      } else {
        // 否则根据搜索条件筛选文件
        _filteredAudioFiles = _audioFiles
            .where((file) => file.split('/').last.split('.').first.toLowerCase().contains(lowerCaseQuery))
            .toList();
      }
    });
  }

  Widget _buildAudioButton(String filePath) {
    String fileName = filePath.split('/').last.split('.').first;

    return ElevatedButton(
      onPressed: () => _audioManager.playAudio(filePath),  // 使用完整路径
      onLongPress: () => _saveAudioFile(filePath),  // 使用完整路径
      child: Text(fileName),
    );
  }

  Widget _buildSection(String title, List<String> files) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: files.map((file) => _buildAudioButton(file)).toList(),
        ),
      ],
    );
  }

  Widget _buildAudioList(String category) {
    List<String> audioFiles = _filteredAudioFiles.isNotEmpty
        ? _filteredAudioFiles
        : _audioFiles.where((file) => file.contains(category)).toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8.0, // 设置按钮之间的水平间距
        runSpacing: 8.0, // 设置按钮之间的垂直间距
        children: audioFiles.map(_buildAudioButton).toList(),
      ),
    );
  }

  Future<void> _saveAudioFile(String filePath) async {
    // 确保路径前面有 'assets/audio/'
    final fullFilePath = 'assets/audio/$filePath';
    try {
      final byteData = await rootBundle.load(fullFilePath);  // 使用完整路径
      final bytes = byteData.buffer.asUint8List();

      String fileName = filePath.split('/').last;  // 提取文件名
      downloadFile(fileName, bytes);  // 调用下载方法
    } catch (e) {
      print("Error loading asset: $e");
    }
  }

  Widget _buildMorePage() {
    final sections = {
      '来自娜娜的吟唱': _audioFiles.where((file) => file.contains('来自娜娜的吟唱')).toList(),
      'AI处理娜娜': _audioFiles.where((file) => file.contains('AI处理娜娜')).toList(),
      '王者全英雄': _audioFiles.where((file) => file.contains('王者全英雄')).toList(),
      '贝塔系列音乐': _audioFiles.where((file) => file.contains('贝塔系列音乐')).toList(),
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sections.entries
            .map((entry) => _buildSection(entry.key, entry.value))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isWideScreen = MediaQuery.of(context).size.width > 600;

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
            onChanged: _filterAudioFiles,
          ),
        ),
      ),
      body: Row(
        children: [
          if (isWideScreen)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                  _pageController.jumpToPage(index);
                  _searchController.clear(); // 清除搜索框
                  _filterAudioFiles(''); // 重置搜索结果
                });
              },
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.home), label: Text('失去')),
                NavigationRailDestination(icon: Icon(Icons.music_note), label: Text('恢复')),
                NavigationRailDestination(icon: Icon(Icons.more_horiz), label: Text('更多')),
              ],
            ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                  _searchController.clear(); // 清除搜索框
                  _filterAudioFiles(''); // 重置搜索结果
                });
              },
              children: [
                _buildAudioList('失去'), // 音频列表
                _buildAudioList('恢复'),
                _buildMorePage(),
                ElevatedButton(
                  onPressed: () => _saveAudioFile('example_audio'), // 保存音频按钮的操作
                  child: const Text('保存音频'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: isWideScreen
          ? null
          : NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
            _pageController.jumpToPage(index);
            _searchController.clear(); // 清除搜索框
            _filterAudioFiles(''); // 重置搜索结果
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: '失去'),
          NavigationDestination(icon: Icon(Icons.music_note), label: '恢复'),
          NavigationDestination(icon: Icon(Icons.more_horiz), label: '更多'),
        ],
      ),
      drawer: const CustomDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: _audioManager.stopAllAudio,
        tooltip: '停止播放',
        child: const Icon(Icons.stop),
      ),
    );
  }
}
