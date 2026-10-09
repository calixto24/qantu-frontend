import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';

void main() {
  // Desactiva la búsqueda/descarga de fuentes en la web
  WidgetsFlutterBinding.ensureInitialized();

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
      initialRoute: AppRoutes.home,

      // Mapa de rutas navegables
      routes: AppRoutes.getRoutes(),
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
