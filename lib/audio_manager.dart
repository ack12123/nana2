import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  final AudioPlayer _audioPlayer = AudioPlayer();

  /// 播放指定的音频文件
  Future<void> playAudio(String fileName) async {
    await stopAudio(); // 停止当前播放的音频
    String fullPath = 'audio/$fileName'; // 确保路径前缀是 'assets/audio/'
    try {
      await _audioPlayer.play(AssetSource(fullPath));
    } catch (e) {
      print('播放错误: $e');
    }
  }

  /// 停止当前播放的音频
  Future<void> stopAudio() async {
    await _audioPlayer.stop();
  }

  /// 释放音频播放器资源
  void dispose() {
    _audioPlayer.dispose();
  }

  /// 停止所有音频播放
  void stopAllAudio() {
    _audioPlayer.stop();
  }
}
