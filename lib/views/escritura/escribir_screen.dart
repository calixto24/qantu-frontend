import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'barra_superior.dart';
import 'respuesta_screen.dart';

class EscribirScreen extends StatefulWidget {
  const EscribirScreen({super.key});

  @override
  State<EscribirScreen> createState() => _EscribirScreenState();
}

class _EscribirScreenState extends State<EscribirScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _enviar() {
    final pregunta = _controller.text.trim();
    if (pregunta.isEmpty) return;

    // Va a la pantalla de respuesta pasando la pregunta escrita
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RespuestaScreen(pregunta: pregunta)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const BarraSuperior(titulo: 'Escribir a Qantu'),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: _buildFormulario(textTheme),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tarjeta con el campo de texto y el boton de enviar
  Widget _buildFormulario(TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.edit_note_rounded, color: AppColors.secondary),
              const SizedBox(width: 8),
              Text(
                'Escribe tu pregunta',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Puedes redactar las preguntas o dudas que tengas del dictado en clases.',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.neutral.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),

          // Campo de texto
          TextField(
            controller: _controller,
            maxLines: 5,
            minLines: 4,
            textInputAction: TextInputAction.newline,
            decoration: InputDecoration(
              hintText: 'Ejemplo: ¿Cuántos suyos tenía el Tawantinsuyo?',
              hintStyle: TextStyle(color: AppColors.neutral.withOpacity(0.5)),
              filled: true,
              fillColor: const Color(0xFFFBF0EB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          // Boton Borrar
          TextButton(
            onPressed: () => _controller.clear(),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 32),
              foregroundColor: AppColors.primary,
            ),
            child: const Text('Borrar', style: TextStyle(fontSize: 12)),
          ),
          const SizedBox(height: 12),

          // Boton Enviar (se activa solo si hay texto)
          SizedBox(
            width: double.infinity,
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _controller,
              builder: (context, value, _) {
                final hayTexto = value.text.trim().isNotEmpty;
                return ElevatedButton.icon(
                  onPressed: hayTexto ? _enviar : null,
                  icon: const Icon(Icons.send_outlined),
                  label: const Text(
                    'Enviar pregunta',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}