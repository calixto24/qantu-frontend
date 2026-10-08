import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class STTService {
  final String baseUrl;

  STTService({this.baseUrl = 'http://localhost:8000/api/v1'});

  Future<String?> transcribeAudioBytes(
    Uint8List audioBytes,
    String filename,
  ) async {
    try {
      final uri = Uri.parse('$baseUrl/stt/transcribir');
      final request = http.MultipartRequest('POST', uri);

      final multipartFile = http.MultipartFile.fromBytes(
        'file',
        audioBytes,
        filename: filename,
      );

      request.files.add(multipartFile);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data['texto'] as String?;
      } else {
        debugPrint('Error en STT API: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Excepción en STTService: $e');
      return null;
    }
  }
}
