import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:record/record.dart';

class VoiceController {
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;

  bool get isRecording => _isRecording;

  Stream<Amplitude> get onAmplitudeChanged =>
      _audioRecorder.onAmplitudeChanged(const Duration(milliseconds: 100));

  Future<bool> start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.opus),
          path: '',
        );
        _isRecording = true;
        return true;
      }
      return false;
    } catch (e) {
      print("Error al iniciar grabación: $e");
      return false;
    }
  }

  Future<Uint8List?> stopAndGetBytes() async {
    try {
      if (!_isRecording) return null;

      // En record 5.x en Web, stop() devuelve la URL de tipo 'blob:http://...'
      final path = await _audioRecorder.stop();
      _isRecording = false;

      if (path != null && path.isNotEmpty) {
        // En Web, descargamos los bytes directamente desde la Blob URL generada por el navegador
        final response = await http.get(Uri.parse(path));
        if (response.statusCode == 200) {
          return response.bodyBytes;
        }
      }
      return null;
    } catch (e) {
      print("Error al detener grabación: $e");
      _isRecording = false;
      return null;
    }
  }

  void dispose() {
    _audioRecorder.dispose();
  }
}
