import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ListeningCard extends StatelessWidget {
  final bool isListening;
  final double currentDb;
  final VoidCallback onToggleMic;
  final VoidCallback onFinish;

  const ListeningCard({
    super.key,
    required this.isListening,
    required this.currentDb,
    required this.onToggleMic,
    required this.onFinish,
  });

  static const List<double> _baseHeights = [
    12.0,
    20.0,
    28.0,
    18.0,
    36.0,
    26.0,
    40.0,
    26.0,
    36.0,
    18.0,
    28.0,
    20.0,
    12.0,
  ];

  double _getNormalizedVolume() {
    if (currentDb < -55.0) return 0.1;
    double normalized = (currentDb + 55.0) / 40.0;
    return normalized.clamp(0.1, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final double volumeFactor = _getNormalizedVolume();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Te estoy escuchando',
            style: textTheme.headlineMedium?.copyWith(
              color: const Color(0xFFB23415),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Habla con claridad cerca del micrófono\ndel dispositivo.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.neutral.withOpacity(0.7),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 36),

          // Botón del micrófono interactivo
          GestureDetector(
            onTap: onToggleMic,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 60),
              width: 140 + (volumeFactor * 22),
              height: 140 + (volumeFactor * 22),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFCEFEA),
              ),
              child: Center(
                child: Container(
                  width: 105,
                  height: 105,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFF7D2C4),
                  ),
                  child: Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isListening
                            ? const Color(0xFFB23415)
                            : AppColors.neutral.withOpacity(0.6),
                      ),
                      child: Icon(
                        isListening ? Icons.mic : Icons.mic_off,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 36),

          // Visualizador de Ondas de Voz
          Container(
            height: 52,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(_baseHeights.length, (index) {
                double calculatedHeight = isListening
                    ? _baseHeights[index] * (volumeFactor * 2.5)
                    : 6.0;

                calculatedHeight = calculatedHeight.clamp(6.0, 44.0);

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 50),
                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                  width: 4.5,
                  height: calculatedHeight,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC04828),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 28),

          // Botón Listo
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onFinish,
              icon: const Icon(Icons.check_circle_outline, size: 20),
              label: const Text('Terminé de hablar (Listo)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB23415),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
                textStyle: textTheme.labelLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
