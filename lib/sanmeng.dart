import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'audio_manager.dart';
import 'custom_drawer.dart';

class SanmengPage extends StatefulWidget {
  const SanmengPage({super.key});

  @override
  SanmengPageState createState() => SanmengPageState();
}

class SanmengPageState extends State<SanmengPage> {
  int _selectedIndex = 0;
  final AudioManager _audioManager = AudioManager();
  final TextEditingController _searchController = TextEditingController();
  List<String> _sanmengFiles = [];
  final List<String> _regainedStrengthFiles = [];
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadAudioFiles();
  }

  Future<void> _loadAudioFiles() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final sanmengFiles = manifestMap.keys
        .where((String key) => key.startsWith('assets/audio/开心姐/'))
        .map((e) => e.replaceFirst('assets/audio/', ''))
        .toList();

    setState(() {
      _sanmengFiles = sanmengFiles;
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
                      label: Text('三梦1'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.music_note),
                      label: Text('三梦2'),
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
                    _buildAudioList(_sanmengFiles),
                    _buildAudioList(_regainedStrengthFiles),
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
                label: '三梦1',
              ),
              NavigationDestination(
                icon: Icon(Icons.music_note),
                label: '三梦2',
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
