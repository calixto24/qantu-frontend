import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../listening/listening_screen.dart';

//import '../../core/routes/app_routes.dart';

class LearningModeScreen extends StatelessWidget {
  const LearningModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          // CONTENEDOR RESPONSIVO
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                // 1. HEADER (Botón atrás y Título)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFEBE6DF,
                            ), // Color crema oscuro del botón
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: AppColors.neutral,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Modo de aprendizaje',
                        style: textTheme.headlineMedium?.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. CONTENIDO PRINCIPAL SCROLLABLE
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Elige cómo aprender hoy',
                          style: textTheme.headlineLarge?.copyWith(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '¿Prefieres hablar con tu voz o escribir en la pantalla? Escoge tu forma favorita.',
                          style: textTheme.bodyLarge?.copyWith(
                            color: AppColors.neutral.withOpacity(0.7),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // 3. TARJETA 1: HABLAR CON QANTU
                        _LearningCard(
                          textTheme: textTheme,
                          badgeText: 'Recomendado para 1° y 2° grado',
                          badgeIcon: Icons.star,
                          badgeBgColor: const Color(0xFFF9E3DE),
                          badgeTextColor: const Color(0xFFA12C1A),
                          mainIcon: Icons.mic_none_rounded,
                          iconBoxColor: AppColors.primary,
                          title: 'Hablar con Qantu',
                          description: 'Presiona el botón rojo y habla sobre tu tarea, cuento o lección del día.',
                          showDots: true,
                          buttonText: 'Usar mi Voz',
                          buttonMainIcon: Icons.record_voice_over_rounded,
                          buttonBgColor: const Color(0xFFB23415),
                          onTap: () {
                            //AQUÍ COLOCAS LA NAVEGACIÓN:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ListeningScreen(),
                              ),
                            );
                          },
                        ),

                        // 4. TARJETA 2: ESCRIBIR A QANTU
                        _LearningCard(
                          textTheme: textTheme,
                          badgeText: 'Para 3° a 6° grado',
                          badgeIcon: Icons.school,
                          badgeBgColor: const Color(0xFFFCE6CF),
                          badgeTextColor: const Color(0xFF914C14),
                          mainIcon: Icons.keyboard_alt_outlined,
                          iconBoxColor: AppColors.secondary,
                          title: 'Escribir a Qantu',
                          subtitle: 'Escribir a Qantu',
                          description: 'Usa el teclado táctil para escribir preguntas, oraciones o resolver preguntas con calma.',
                          showDots: false,
                          buttonText: 'Escribir',
                          buttonMainIcon: Icons.edit_note_rounded,
                          buttonBgColor: const Color(0xFF9E5616),
                          onTap: () {
                            // Lógica para ir a la pantalla de texto
                            // Navigator.pushNamed(context, AppRoutes.textoEntrada);
                          },
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// WIDGET REUTILIZABLE PARA LAS TARJETAS
class _LearningCard extends StatelessWidget {
  final TextTheme textTheme;
  final String badgeText;
  final IconData badgeIcon;
  final Color badgeBgColor;
  final Color badgeTextColor;
  final IconData mainIcon;
  final Color iconBoxColor;
  final String title;
  final String? subtitle;
  final String description;
  final bool showDots;
  final String buttonText;
  final IconData buttonMainIcon;
  final Color buttonBgColor;
  final VoidCallback onTap;

  const _LearningCard({
    required this.textTheme,
    required this.badgeText,
    required this.badgeIcon,
    required this.badgeBgColor,
    required this.badgeTextColor,
    required this.mainIcon,
    required this.iconBoxColor,
    required this.title,
    this.subtitle,
    required this.description,
    required this.showDots,
    required this.buttonText,
    required this.buttonMainIcon,
    required this.buttonBgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(20),
              ),
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: buttonBgColor.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                transform: Matrix4.translationValues(40, 40, 0),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. BADGE
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: badgeBgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(badgeIcon, size: 14, color: badgeTextColor),
                      const SizedBox(width: 6),
                      Text(
                        badgeText,
                        style: textTheme.labelLarge?.copyWith(
                          color: badgeTextColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 2. ICONO PRINCIPAL Y TÍTULO
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: iconBoxColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(mainIcon, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: textTheme.headlineMedium?.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (subtitle != null) ...[
                            Text(
                              subtitle!,
                              style: textTheme.bodyMedium?.copyWith(
                                color: iconBoxColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 3. DESCRIPCIÓN
                Text(
                  description,
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.neutral.withOpacity(0.8),
                    height: 1.4,
                  ),
                ),

                if (showDots) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC8E6C9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 16,
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBE8D8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ],

                SizedBox(height: showDots ? 16 : 24),

                // 4. BOTÓN DE ACCIÓN
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonBgColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(buttonMainIcon, size: 22),
                        const SizedBox(width: 10),
                        Text(
                          buttonText,
                          style: textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
