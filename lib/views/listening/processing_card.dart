import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ProcessingCard extends StatelessWidget {
  const ProcessingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
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
            'Comprendiendo tu voz',
            style: textTheme.headlineMedium?.copyWith(
              color: const Color(0xFFB23415),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Espere un momento por favor...',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.neutral.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 40),

          // Spinner Indeterminado
          SizedBox(
            width: 90,
            height: 90,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFAF1EB),
                  ),
                  child: const Icon(
                    Icons.local_florist,
                    color: Color(0xFFB23415),
                    size: 28,
                  ),
                ),
                const SizedBox(
                  width: 90,
                  height: 90,
                  child: CircularProgressIndicator(
                    strokeWidth: 7,
                    strokeCap: StrokeCap.round,
                    backgroundColor: Color(0xFFF3ECE6),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFF28132),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 48),

          // Barra Horizontal de Carga
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              minHeight: 12,
              backgroundColor: Color(0xFFF3ECE6),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF28132)),
            ),
          ),
        ],
      ),
    );
  }
}
