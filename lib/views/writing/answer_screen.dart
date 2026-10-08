import 'package:flutter/material.dart';
import 'package:qantu_frontend/views/widgets/qantu_page_layout.dart';

import '../../core/theme/app_colors.dart';
import '../../services/qantu_service.dart';

class AnswerScreen extends StatefulWidget {
  final String pregunta;

  const AnswerScreen({super.key, required this.pregunta});

  @override
  State<AnswerScreen> createState() => _AnswerScreenState();
}

class _AnswerScreenState extends State<AnswerScreen> {
  // Hoy usa el servicio simulado. Cuando el backend este listo,
  // solo se cambia por ApiQantuService().
  final QantuService _service = MockQantuService();

  late Future<String> _respuesta;
  bool _reproduciendo = false;

  @override
  void initState() {
    super.initState();
    _respuesta = _service.responder(widget.pregunta);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return QantuPageLayout(
      title: 'Respuesta de Qantu',
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

  // Tarjeta con la pregunta que hizo el niño
  Widget _buildPregunta(TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFBE8D8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF8D5C4),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.edit, size: 12, color: AppColors.primary),
                SizedBox(width: 4),
                Text(
                  'Preguntaste',
                  style: TextStyle(
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

  // Tarjeta con el reproductor de audio y la respuesta (o cargando)
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
      child: FutureBuilder<String>(
        future: _respuesta,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
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

          if (snapshot.hasError) {
            return const Text(
              'No pude responder en este momento. Inténtalo otra vez.',
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildReproductor(),
              const SizedBox(height: 14),
              Text(
                snapshot.data ?? '',
                style: textTheme.bodyLarge?.copyWith(height: 1.5),
              ),
            ],
          );
        },
      ),
    );
  }

  // Reproductor verde (por ahora solo cambia el icono, sin audio real)
  Widget _buildReproductor() {
    const verde = Color(0xFF2E7D32);

    return InkWell(
      onTap: () => setState(() => _reproduciendo = !_reproduciendo),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: verde,
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
            const Expanded(
              child: Text(
                'Escuchar respuesta completa (Uyariy)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '0:18',
                style: TextStyle(color: Colors.white, fontSize: 11),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.volume_up_rounded, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  // Botones de abajo: otra pregunta y cambiar a modo voz
  Widget _buildBotones() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          // Vuelve a la pantalla de escribir
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.keyboard_alt_outlined),
          label: const Text(
            'Escribir otra pregunta',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
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
            // TODO: navegar a la pantalla de modo voz (la hace otro compañero)
          },
          icon: const Icon(Icons.mic_none_rounded),
          label: const Text(
            'Cambiar a modo voz',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          style: TextButton.styleFrom(foregroundColor: const Color(0xFF2E7D32)),
        ),
      ],
    );
  }
}
