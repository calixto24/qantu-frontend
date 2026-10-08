import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioPlayerController {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playFromUrl(String audioUrl) async {
    try {
      // Si la URL es relativa (/audio/qantu_xxx.wav), le añadimos la base del backend
      final fullUrl = audioUrl.startsWith('http')
          ? audioUrl
          : 'http://localhost:8000$audioUrl';

      await _player.stop();
      await _player.play(UrlSource(fullUrl));
    } catch (e) {
      debugPrint("Error al reproducir audio TTS: $e");
    }
  }

  Future<void> stop() async {
    await _player.stop();
  }

  void dispose() {
    _player.dispose();
  }
}
