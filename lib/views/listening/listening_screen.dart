import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qantu_frontend/controllers/voice_controller.dart';
import 'package:qantu_frontend/core/routes/app_routes.dart';
import 'package:qantu_frontend/services/stt_service.dart';
import 'package:qantu_frontend/views/listening/listening_card.dart';
import 'package:qantu_frontend/views/listening/processing_card.dart';
import 'package:qantu_frontend/views/widgets/qantu_page_layout.dart';
import 'package:record/record.dart';

class ListeningScreen extends StatefulWidget {
  const ListeningScreen({super.key});

  @override
  State<ListeningScreen> createState() => _ListeningScreenState();
}

class _ListeningScreenState extends State<ListeningScreen> {
  final VoiceController _voiceController = VoiceController();
  final STTService _sttService = STTService();

  StreamSubscription<Amplitude>? _ampSub;
  bool isListening = false;
  bool isProcessing = false;
  double currentDb = -160.0;

  @override
  void initState() {
    super.initState();
    _initMicrophone();
  }

  Future<void> _initMicrophone() async {
    // Cancelar suscripción previa si existía
    await _ampSub?.cancel();

    final started = await _voiceController.start();
    if (started && mounted) {
      setState(() {
        isListening = true;
      });

      // IMPORTANTE: Volver a escuchar los cambios de decibelios para la animación
      _ampSub = _voiceController.onAmplitudeChanged.listen((amp) {
        if (mounted && isListening) {
          setState(() {
            currentDb = amp.current;
          });
        }
      });
    }
  }

  Future<void> _toggleMic() async {
    if (isListening) {
      // Apagar micrófono y detener animación
      await _ampSub?.cancel();
      await _voiceController.stopAndGetBytes();
      if (mounted) {
        setState(() {
          isListening = false;
          currentDb = -160.0; // Resetear volumen a cero
        });
      }
    } else {
      // Encender micrófono y REACTIVAR la animación
      await _initMicrophone();
    }
  }

  Future<void> _handleFinishSpeaking() async {
    await _ampSub?.cancel();
    setState(() {
      isListening = false;
      isProcessing = true; // Mostrar la vista de procesamiento
    });

    // Capturar bytes
    final bytes = await _voiceController.stopAndGetBytes();

    if (bytes != null && bytes.isNotEmpty) {
      // Enviar a FastAPI Whisper
      final text = await _sttService.transcribeAudioBytes(bytes, 'record.webm');

      if (mounted && text != null && text.trim().isNotEmpty) {
        // ÉXITO: Navegar a la pantalla de respuesta
        Navigator.pushNamed(context, AppRoutes.answer, arguments: text);
        return;
      }
    }

    // Si falló o el audio vino vacío:
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se logró entender el audio. Intenta hablar de nuevo.',
          ),
        ),
      );
      setState(() => isProcessing = false);
      _initMicrophone(); // Reiniciar micrófono limpiamente
    }
  }

  @override
  void dispose() {
    _ampSub?.cancel();
    _voiceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QantuPageLayout(
      title: 'Hablar con Qantu',
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Center(
        child: isProcessing
            ? const ProcessingCard()
            : ListeningCard(
                isListening: isListening,
                currentDb: currentDb,
                onToggleMic: _toggleMic,
                onFinish: _handleFinishSpeaking,
              ),
      ),
    );
  }
}
