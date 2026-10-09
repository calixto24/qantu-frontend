import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioPlayerController {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  // Escuchar estado de reproducción
  Stream<PlayerState> get onPlayerStateChanged => _player.onPlayerStateChanged;

  Future<void> playFromUrl(String audioUrl) async {
    try {
      // Concatenar el servidor si la URL es relativa (/audio/qantu_xxx.wav)
      final fullUrl = audioUrl.startsWith('http')
          ? audioUrl
          : 'http://localhost:8000$audioUrl';

      await _player.stop();
      await _player.play(UrlSource(fullUrl));
      _isPlaying = true;
    } catch (e) {
      debugPrint("❌ Error al reproducir audio TTS: $e");
    }
  }

  Future<void> pause() async {
    await _player.pause();
    _isPlaying = false;
  }

  Future<void> resume() async {
    await _player.resume();
    _isPlaying = true;
  }

  Future<void> stop() async {
    await _player.stop();
    _isPlaying = false;
  }

  void dispose() {
    _player.dispose();
  }
}
