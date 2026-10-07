import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart'; 

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          // CONTENEDOR RESPONSIVO: Centra y limita el ancho máximo para Web/Laptops
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. HEADER (Qantu + Red Local Activa)
                  _buildHeader(textTheme),

                  const SizedBox(height: 20),

                  // 2. TARJETA PRINCIPAL DE BIENVENIDA
                  _buildWelcomeCard(textTheme),

                  const SizedBox(height: 16),

                  // 3. TARJETA CARACTERÍSTICA 1: 100% Sin Internet
                  _buildFeatureCard(
                    textTheme: textTheme,
                    iconBgColor: const Color(0xFFC8E6C9),
                    icon: Icons.wifi_off_rounded,
                    iconColor: const Color(0xFF2E7D32),
                    title: '100% Sin Internet',
                    titleBadge: const Icon(
                      Icons.check_circle,
                      color: Color(0xFF2E7D32),
                      size: 18,
                    ),
                    description: 'Funciona con el servidor local del aula (Raspberry Pi/Laptop) sin gastar datos móviles.',
                  ),

                  const SizedBox(height: 12),

                  // 4. TARJETA CARACTERÍSTICA 2: Currículo Nacional EIB
                  _buildFeatureCard(
                    textTheme: textTheme,
                    iconBgColor: const Color(0xFFFFE0B2),
                    icon: Icons.menu_book_rounded,
                    iconColor: AppColors.secondary,
                    title: 'Currículo Nacional',
                    titleBadge: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'EIB',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.neutral,
                        ),
                      ),
                    ),
                    description: 'Diseñado para educación primaria rural y contextualizada al territorio andino.',
                  ),

                  const SizedBox(height: 24),

                  // 5. BOTÓN PRINCIPAL "Empezar ahora"
                  ElevatedButton(
                    onPressed: () {
                      // NAVEGACIÓN: Va a la pantalla de elección de modo
                      Navigator.pushNamed(context, AppRoutes.modoAprendizaje);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Empezar ahora',
                          style: textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- COMPONENTES INTERNOS (REUTILIZABLES Y MANTENIBLES) ---

  // Header de la pantalla
  Widget _buildHeader(TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Qantu',
          style: textTheme.headlineMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE8ECE3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.tertiary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Red Local Activa',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.tertiary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Tarjeta de Bienvenida con Avatar e Insignia
  Widget _buildWelcomeCard(TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Stack para el Avatar + Icono de Flor superpuesto
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.background,
                child: const Icon(
                  Icons.person,
                  size: 50,
                  color: Color(0xFFE0D3C1),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: AppColors.tertiary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.local_florist_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Píldora ¡BIENVENIDO/A!
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFBE8D8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.chevron_left_rounded,
                  size: 18,
                  color: AppColors.secondary,
                ),
                Text(
                  '¡BIENVENIDO/A!',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Título Principal
          Text(
            '¡Hola Amigos!',
            style: textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // Subtítulo explicativo
          Text(
            '¿Qué te gustaría aprender hoy? Explora matemáticas, ciencias, cuentos y tradiciones con el apoyo inteligente de Qantu.',
            style: textTheme.bodyLarge?.copyWith(
              color: AppColors.neutral.withOpacity(0.7),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Widget reutilizable para Tarjetas de Características
  Widget _buildFeatureCard({
    required TextTheme textTheme,
    required Color iconBgColor,
    required IconData icon,
    required Color iconColor,
    required String title,
    Widget? titleBadge,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Círculo del Ícono
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 12),

          // Textos (Título + Descripción)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (titleBadge != null) ...[
                      const SizedBox(width: 6),
                      titleBadge,
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.neutral.withOpacity(0.7),
                    height: 1.3,
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
