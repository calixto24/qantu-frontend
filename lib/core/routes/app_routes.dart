import 'package:flutter/material.dart';
import 'package:qantu_frontend/views/answer/answer_screen.dart';

import '../../views/home/home_screen.dart';
import '../../views/learning_mode/learning_mode_screen.dart';
import '../../views/listening/listening_screen.dart';
import '../../views/writing/writing_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String learningMode = '/learning-mode';
  static const String listening = '/listening';
  static const String writing = '/writing';
  static const String answer = '/answer';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const HomeScreen(),
      learningMode: (context) => const LearningModeScreen(),
      listening: (context) => const ListeningScreen(),
      writing: (context) => const WritingScreen(),
    };
  }

  // Manejador de rutas con argumentos dinámicos
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == answer) {
      String pregunta = 'Sin pregunta';
      bool isVoice = true;

      if (settings.arguments is Map<String, dynamic>) {
        final args = settings.arguments as Map<String, dynamic>;
        pregunta = args['pregunta'] as String? ?? 'Sin pregunta';
        isVoice = args['isVoice'] as bool? ?? true;
      } else if (settings.arguments is String) {
        pregunta = settings.arguments as String;
      }

      return MaterialPageRoute(
        builder: (context) =>
            AnswerScreen(pregunta: pregunta, isVoice: isVoice),
      );
    }
    return null;
  }
}
