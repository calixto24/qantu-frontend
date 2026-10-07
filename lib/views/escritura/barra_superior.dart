import 'package:flutter/material.dart';

/// Barra superior de las pantallas internas: boton volver + titulo.
class BarraSuperior extends StatelessWidget {
  final String titulo;

  const BarraSuperior({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFFFFF8F5),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.maybePop(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF1E6E0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_rounded, size: 22),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            titulo,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}