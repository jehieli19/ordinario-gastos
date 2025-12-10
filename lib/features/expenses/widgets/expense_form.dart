import 'package:flutter/material.dart';

class ExpenseForm extends StatelessWidget {
  const ExpenseForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: const [
          Text('Formulario de gasto'),
          // Aquí irán los campos: monto, descripción, categoría, método de pago, fecha
        ],
      ),
    );
  }
}
