import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:qantu_frontend/controllers/audio_player_controller.dart';
import 'package:qantu_frontend/core/routes/app_routes.dart';
import 'package:qantu_frontend/core/theme/app_colors.dart';
import 'package:qantu_frontend/services/websocket_service.dart';
import 'package:qantu_frontend/views/widgets/qantu_page_layout.dart';

class AnswerScreen extends StatefulWidget {
  final String pregunta;
  final bool isVoice;

  const AnswerScreen({super.key, required this.pregunta, this.isVoice = true});

  @override
  State<AnswerScreen> createState() => _AnswerScreenState();
}

class _AnswerScreenState extends State<AnswerScreen> {
  final WebSocketService _wsService = WebSocketService();
  final AudioPlayerController _audioController = AudioPlayerController();

  StreamSubscription? _wsSubscription;
  StreamSubscription? _playerStateSubscription;

  String _respuestaTexto = "";
  String? _audioUrl;
  bool _estaPensando = true;
  bool _estaGenerando = false;
  bool _error = false;
  bool _reproduciendo = false;

  @override
  void initState() {
    super.initState();
    _iniciarConexionWS();
    _escucharEstadoAudio();
  }

  void _escucharEstadoAudio() {
    _playerStateSubscription = _audioController.onPlayerStateChanged.listen((
      state,
    ) {
      if (mounted) {
        setState(() {
          _reproduciendo = state == PlayerState.playing;
        });
      }
    });
  }

  void _iniciarConexionWS() {
    _wsService.connect('ws://localhost:8000/ws/chat');

    _wsSubscription = _wsService.messages.listen(
      (data) {
        final event = data['event'];
        final content = data['content'] as String? ?? "";

        if (event == 'start') {
          if (mounted) {
            setState(() {
              _estaPensando = false;
              _estaGenerando = true;
              _respuestaTexto = "";
              _audioUrl = null;
            });
          }
        } else if (event == 'chunk') {
          if (mounted) {
            setState(() {
              _respuestaTexto += content;
            });
          }
        } else if (event == 'end') {
          // Imprime en consola para depurar exacto qué está llegando en el evento 'end'
          print("📩 Evento END recibido desde el backend: $data");

          final urlRecibida = data['audio_url'] as String?;

          if (mounted) {
            setState(() {
              _estaGenerando = false;
              _audioUrl = urlRecibida;
            });

            if (_audioUrl != null && _audioUrl!.isNotEmpty) {
              print("🔊 Reproduciendo audio desde: $_audioUrl");
              _audioController.playFromUrl(_audioUrl!);
            } else {
              print("⚠️ No se recibió audio_url o vino vacío.");
            }
          }
        } else if (event == 'error') {
          if (mounted) {
            setState(() {
              _estaPensando = false;
              _estaGenerando = false;
              _error = true;
            });
          }
        }
      },
      onError: (err) {
        if (mounted) {
          setState(() {
            _estaPensando = false;
            _estaGenerando = false;
            _error = true;
          });
        }
      },
    );

    _wsService.sendUserText(widget.pregunta);
  }

  void _toggleReproduccionAudio() {
    if (_audioUrl == null || _audioUrl!.isEmpty) return;

    if (_reproduciendo) {
      _audioController.pause();
    } else {
      if (_audioController.isPlaying) {
        _audioController.resume();
      } else {
        _audioController.playFromUrl(_audioUrl!);
      }
    }
  }

  @override
  void dispose() {
    _wsSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _audioController.stop();
    _audioController.dispose();
    _wsService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return QantuPageLayout(
      title: 'Respuesta de Qantu',
      onBackPressed: () {
        Navigator.pushReplacementNamed(context, AppRoutes.learningMode);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildPregunta(textTheme),
          const SizedBox(height: 16),
          _buildRespuesta(textTheme),
          const SizedBox(height: 20),
          _buildBotones(),
        ],
      ),
    );
  }

  // --- Mantenemos _buildPregunta ---
  Widget _buildPregunta(TextTheme textTheme) {
    final isVoice = widget.isVoice;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFBE8D8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chip/Badge dinámico
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF8D5C4),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isVoice ? Icons.mic : Icons.edit_note_rounded,
                  size: 14,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  isVoice ? 'Dijiste por voz' : 'Escribiste por teclado',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'TU PREGUNTA:',
            style: textTheme.bodyMedium?.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '«${widget.pregunta}»',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRespuesta(TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _buildContenidoRespuesta(textTheme),
    );
  }

  Widget _buildContenidoRespuesta(TextTheme textTheme) {
    if (_estaPensando) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: 12),
            Text('Qantu está pensando...'),
          ],
        ),
      );
    }

    if (_error) {
      return const Text(
        'No pude responder en este momento. Inténtalo otra vez.',
        style: TextStyle(color: Colors.red),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildReproductor(),
        const SizedBox(height: 14),
        Text(
          _respuestaTexto,
          style: textTheme.bodyLarge?.copyWith(height: 1.5),
        ),
        if (_estaGenerando)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }

  // Reproductor verde interactivo
  Widget _buildReproductor() {
    const verde = Color(0xFF2E7D32);
    final tieneAudio = _audioUrl != null && _audioUrl!.isNotEmpty;

    return InkWell(
      onTap: tieneAudio ? _toggleReproduccionAudio : null,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: tieneAudio ? verde : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              _reproduciendo
                  ? Icons.pause_circle_outline_rounded
                  : Icons.play_circle_outline_rounded,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                tieneAudio
                    ? (_reproduciendo
                          ? 'Pausar audio'
                          : 'Escuchar respuesta completa')
                    : 'Sintetizando voz de Qantu...',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            if (!tieneAudio)
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            else
              const Icon(
                Icons.volume_up_rounded,
                color: Colors.white,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotones() {
    final isVoice = widget.isVoice;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              isVoice ? AppRoutes.listening : AppRoutes.writing,
            );
          },
          icon: Icon(isVoice ? Icons.mic : Icons.keyboard_alt_outlined),
          label: Text(
            isVoice ? 'Volver a hablar' : 'Escribir otra pregunta',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
        ),
        const SizedBox(height: 8),

        TextButton.icon(
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              isVoice ? AppRoutes.writing : AppRoutes.listening,
            );
          },
          icon: Icon(
            isVoice ? Icons.keyboard_alt_outlined : Icons.mic_none_rounded,
          ),
          label: Text(
            isVoice ? 'Cambiar a modo teclado' : 'Cambiar a modo voz',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          style: TextButton.styleFrom(foregroundColor: AppColors.secondary),
        ),
      ],
    );
  }
}
