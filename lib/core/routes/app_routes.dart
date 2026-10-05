import 'package:flutter/material.dart';

import '../../views/home/inicio_screen.dart';

class AppRoutes {
  static const String inicio = '/';
  // static const String modoAprendizaje = '/modo-aprendizaje';
  // static const String vozEscuchando = '/voz-escuchando';
  // static const String vozProcesando = '/voz-procesando';
  // static const String textoEntrada = '/texto-entrada';
  // static const String respuestaChat = '/respuesta-chat';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      inicio: (context) => const InicioScreen(),
      // modoAprendizaje: (context) => const ModoAprendizajeScreen(),
      // vozEscuchando: (context) => const VoiceListeningScreen(),
      // vozProcesando: (context) => const VoiceProcessingScreen(),
      // textoEntrada: (context) => const TextInputScreen(),
      // respuestaChat: (context) => const ChatResponseScreen(),
    };
  }
}
