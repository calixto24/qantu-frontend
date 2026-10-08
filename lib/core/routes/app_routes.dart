import 'package:flutter/material.dart';

import '../../views/home/home_screen.dart';
import '../../views/learning_mode/learning_mode_screen.dart';
import '../../views/listening/listening_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String learningMode = '/learning-mode';
  static const String listening = '/listening';
  // static const String processing = '/processing';
  // static const String textInput = '/text-input';
  // static const String chatResponse = '/chat-response';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const HomeScreen(),
      learningMode: (context) => const LearningModeScreen(),
      listening: (context) => const ListeningScreen(),
      // vozProcesando: (context) => const VoiceProcessingScreen(),
      // textoEntrada: (context) => const TextInputScreen(),
      // respuestaChat: (context) => const ChatResponseScreen(),
    };
  }
}
