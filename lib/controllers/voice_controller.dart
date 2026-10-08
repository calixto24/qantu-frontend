import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:record/record.dart';

class VoiceController {
  final AudioRecorder _recorder = AudioRecorder();

  Future<bool> start() async {
    try {
      if (await _recorder.hasPermission()) {
        // En Web usaremos AudioEncoder.opus o aacLc para garantizar compatibilidad
        await _recorder.start(
          const RecordConfig(
            encoder: kIsWeb ? AudioEncoder.opus : AudioEncoder.pcm16bits,
            sampleRate: 44100,
          ),
          path: '',
        );
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error al iniciar micrófono: $e');
      return false;
    }
  }

  Future<Uint8List?> stopAndGetBytes() async {
    try {
      final path = await _recorder.stop();
      if (path == null || path.isEmpty) return null;

      if (path.startsWith('http') || path.startsWith('blob:')) {
        final response = await http.get(Uri.parse(path));
        if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
          return response.bodyBytes;
        }
      } else {
        final bytes = await http.readBytes(Uri.parse(path));
        return bytes;
      }
    } catch (e) {
      debugPrint('Error al detener grabación: $e');
    }
    return null;
  }

  Stream<Amplitude> get onAmplitudeChanged =>
      _recorder.onAmplitudeChanged(const Duration(milliseconds: 50));

  void dispose() {
    _recorder.dispose();
  }
}
