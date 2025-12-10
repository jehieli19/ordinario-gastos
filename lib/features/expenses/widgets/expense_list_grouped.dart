import 'package:flutter/material.dart';

class ExpenseListGrouped extends StatelessWidget {
  const ExpenseListGrouped({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        // Aquí irán los grupos de gastos por fecha
        ListTile(title: Text('Gastos agrupados por fecha')),
      ],
    );
  }
}
