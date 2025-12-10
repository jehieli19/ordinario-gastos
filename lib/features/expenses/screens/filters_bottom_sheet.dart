import 'package:flutter/material.dart';

class FiltersBottomSheet extends StatelessWidget {
  const FiltersBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text('Filtros'),
          // Aquí irán los filtros: rango de fechas, chips de categorías, botón aplicar
        ],
      ),
    );
  }
}
