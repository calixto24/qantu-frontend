import 'package:flutter/material.dart';

// 1. IMPORTA TUS ARCHIVOS DE CONFIGURACIÓN
// Ajusta las rutas según donde guardaste cada archivo
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const QantuApp());
}

class QantuApp extends StatelessWidget {
  const QantuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qantu IA',
      debugShowCheckedModeBanner: false,

      // 2. APLICA TU TEMA GLOBAL AQUÍ
      theme: AppTheme.lightTheme,

      home: const StyleTestScreen(),
    );
  }
}

// 3. PANTALLA DE PRUEBA DE ESTILOS
class StyleTestScreen extends StatelessWidget {
  const StyleTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Qantu - Prueba de Estilos',
          style: textTheme.headlineMedium?.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // PRUEBA DE TIPOGRAFÍAS
            Text('Título Headline (Quicksand)', style: textTheme.headlineLarge),
            const SizedBox(height: 8),
            Text(
              'Subtítulo Headline (Quicksand)',
              style: textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Este es un texto de cuerpo principal (Nunito). Se usa para las respuestas de la IA y mensajes de chat.',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Texto de etiqueta o botón (Nunito SemiBold)',
              style: textTheme.labelLarge,
            ),

            const Divider(height: 40, thickness: 1.5),

            // PRUEBA DE COLORES
            Text(
              'Paleta de Colores (Flor de la Cantuta):',
              style: textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),

            _ColorBox(
              color: AppColors.primary,
              name: 'Primary (#D94B2B) - Rojo Cantuta',
            ),
            _ColorBox(
              color: AppColors.secondary,
              name: 'Secondary (#E07A28) - Naranja Flor',
            ),
            _ColorBox(
              color: AppColors.tertiary,
              name: 'Tertiary (#52854C) - Verde Hojas',
            ),
            _ColorBox(
              color: AppColors.neutral,
              name: 'Neutral (#24201D) - Texto Oscuro',
              textColor: Colors.white,
            ),
            _ColorBox(
              color: AppColors.background,
              name: 'Background (#F7F3EE) - Crema Claro',
            ),
          ],
        ),
      ),
    );
  }
}

// WIDGET AUXILIAR PARA MOSTRAR LOS BLOQUES DE COLOR
class _ColorBox extends StatelessWidget {
  final Color color;
  final String name;
  final Color textColor;

  const _ColorBox({
    required this.color,
    required this.name,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Text(
        name,
        style: Theme.of(context).textTheme.bodyLarge
            ?.copyWith(color: textColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}
