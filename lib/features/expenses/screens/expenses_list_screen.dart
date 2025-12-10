import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/expense_provider.dart';
import '../widgets/expenses_filters.dart';
import '../../../core/constants/categories.dart';

class ExpensesListScreen extends StatelessWidget {
  const ExpensesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger fetch on first build if needed, but better handling
    // usually involves a wrapper or InitState in a parent.
    // For StatelessWidget, we can verify if empty and not loading.
    final provider = Provider.of<ExpenseProvider>(context, listen: false);
    if (provider.expenses.isEmpty && !provider.loading) {
      provider.fetchExpenses();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Gastos'),
      ),
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, _) {
          if (provider.loading) {
            return Center(
              child: Lottie.network(
                'https://assets9.lottiefiles.com/packages/lf20_b88nh30c.json',
                width: 200,
                height: 200,
              ),
            );
          }
          
          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${provider.errorMessage}'),
                  TextButton(
                    onPressed: provider.fetchExpenses,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          final filtered = provider.filteredExpenses;

          return Column(
            children: [
              ExpensesFilters(
                onChanged: (range, cats, search) {
                  provider.setFilters(
                    range: range,
                    categories: cats,
                    search: search,
                  );
                },
              ),
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.receipt_long,
                                  size: 64, color: Colors.grey),
                              const SizedBox(height: 16),
                              const Text('No hay gastos registrados'),
                              Lottie.network(
                                'https://assets10.lottiefiles.com/packages/lf20_w51pcehl.json',
                                width: 200,
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final expense = filtered[index];
                          final categoryData =
                              categoryDetails[Category.values.firstWhere(
                            (e) =>
                                categoryNames[e] == expense.category,
                            orElse: () => Category.others,
                          )];

                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    categoryData?.color.withOpacity(0.2) ??
                                        Colors.grey.withOpacity(0.2),
                                child: Icon(
                                  categoryData?.icon ?? Icons.category,
                                  color: categoryData?.color ?? Colors.grey,
                                ),
                              ),
                              title: Text(
                                expense.description,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${expense.category} • ${expense.expenseDate.day}/${expense.expenseDate.month}/${expense.expenseDate.year}',
                              ),
                              trailing: Text(
                                NumberFormat.currency(
                                  locale: 'es_MX',
                                  symbol: '\$',
                                ).format(expense.amount),
                                style: TextStyle(
                                  color: expense.amount > 1000
                                      ? Colors.red
                                      : Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              onTap: () => context.go('/expenses/${expense.id}'),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/expenses/add'),
        label: const Text('Nuevo Gasto'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
