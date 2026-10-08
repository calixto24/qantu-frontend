import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final StreamController<Map<String, dynamic>> _messageController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get messages => _messageController.stream;

  void connect(String url) {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _channel!.stream.listen(
        (data) {
          final decoded = jsonDecode(data as String) as Map<String, dynamic>;
          _messageController.add(decoded);
        },
        onError: (error) {
          _messageController.addError(error);
        },
        onDone: () {
          debugPrint("WebSocket conexión cerrada");
        },
      );
    } catch (e) {
      debugPrint("Error al conectar WebSocket: $e");
    }
  }

  void sendUserText(String text) {
    if (_channel != null) {
      final payload = jsonEncode({"event": "user_text", "payload": text});
      _channel!.sink.add(payload);
    }
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }
}
