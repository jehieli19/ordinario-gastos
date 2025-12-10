import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/expense_provider.dart';
import '../../../core/constants/categories.dart';
// import '../../../core/models/expense.dart'; // Often not needed if using Provider's list, but useful for type checking

class ExpenseDetailScreen extends StatelessWidget {
  const ExpenseDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final id = GoRouterState.of(context).pathParameters['id'];
    final provider = Provider.of<ExpenseProvider>(context);
    
    // Find expense safely
    final expense = provider.expenses.where((e) => e.id == id).isNotEmpty
        ? provider.expenses.firstWhere((e) => e.id == id)
        : null;

    if (expense == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalle de Gasto')),
        body: const Center(child: Text('Gasto no encontrado.')),
      );
    }

    final categoryData = categoryDetails[Category.values.firstWhere(
      (e) => categoryNames[e] == expense.category,
      orElse: () => Category.others,
    )];

    final theme = Theme.of(context);

    // Map payment method to readable name
    String paymentMethodName = 'Otro';
    if (expense.paymentMethod == 'cash') paymentMethodName = 'Efectivo';
    if (expense.paymentMethod == 'card') paymentMethodName = 'Tarjeta';
    if (expense.paymentMethod == 'transfer') paymentMethodName = 'Transferencia';

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Gasto')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Header Card with Amount and Icon
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: categoryData?.color.withOpacity(0.1),
                      child: Icon(
                        categoryData?.icon ?? Icons.category,
                        size: 40,
                        color: categoryData?.color,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      NumberFormat.simpleCurrency(locale: 'es_MX')
                          .format(expense.amount),
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      expense.description,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Details Section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.category_outlined),
                    title: const Text('Categoría'),
                    trailing: Text(
                      expense.category,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.calendar_today_outlined),
                    title: const Text('Fecha'),
                    trailing: Text(
                      DateFormat('dd/MM/yyyy').format(expense.expenseDate),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.payment_outlined),
                    title: const Text('Método de Pago'),
                    trailing: Text(
                      paymentMethodName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.push('/expenses/add', extra: expense);
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Editar'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Eliminar Gasto'),
                          content: const Text(
                            '¿Estás seguro de eliminar este gasto permanentemente?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text(
                                'Eliminar',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        final success =
                            await provider.deleteExpense(expense.id);
                        if (success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Gasto eliminado correctamente'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          context.pop(); // Go back to list
                        }
                      }
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Eliminar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
