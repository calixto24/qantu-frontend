import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';

void main() {
  runApp(const QantuApp());
}

class QantuApp extends StatelessWidget {
  const QantuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qantu',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      // Pantalla inicial
      initialRoute: AppRoutes.inicio,

      // Mapa de rutas navegables
      routes: AppRoutes.getRoutes(),
    );
  }
}
