import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/expense_provider.dart';
import '../../../core/models/expense.dart';
import '../../../core/constants/categories.dart'; // Import for distinct categories if needed later
import '../../expenses/widgets/expenses_filters.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Note: We use the filtered expenses from the provider OR we can recalculate 
    // strictly for the summary screen. 
    // The requirement implies this screen might need its own filters or use the global one.
    // The previous implementation had local state filters.
    // To be strictly Stateless, we should rely on the Provider's filter state if we want persistence,
    // OR just use a simpler approach if the user wants "practicality".
    // Given the previous refactor of ExpenseProvider to hold filter state, 
    // we can reuse that seamlessly!

    final provider = Provider.of<ExpenseProvider>(context);
    final theme = Theme.of(context);
    
    // We can use the provider's filtered list for the breakdown, 
    // but the Month/Day totals usually refer to "Actual" month/day regardless of filters, 
    // or arguably "Within the filtered range". 
    // Let's assume the Dashboard cards should show the ACTUAL CURRENT Month/Day context 
    // to match the "Resumen Básico" requirement list, 
    // while the list below matches the filters or all expenses.
    
    // Let's use the FULL list for the top cards to always show current status, 
    // and the filtered list for the bottom breakdown.
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    final totalMes = provider.expenses
        .where((e) => e.expenseDate.month == now.month && e.expenseDate.year == now.year)
        .fold<double>(0, (sum, e) => sum + e.amount);
        
    final totalDia = provider.expenses
        .where((e) =>
            e.expenseDate.year == today.year &&
            e.expenseDate.month == today.month &&
            e.expenseDate.day == today.day)
        .fold<double>(0, (sum, e) => sum + e.amount);

    final filtered = provider.filteredExpenses;

    // Grouping logic for the list
    final Map<String, List<Expense>> grouped = {};
    for (final e in filtered) {
      final key = DateFormat('yyyy-MM-dd').format(e.expenseDate);
      grouped.putIfAbsent(key, () => []).add(e);
    }
    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen Financiero'),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Stats Row
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    title: 'Gasto Mensual',
                    amount: totalMes,
                    icon: Icons.calendar_month,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _SummaryCard(
                    title: 'Gasto Diario',
                    amount: totalDia,
                    icon: Icons.today,
                    color: Colors.orangeAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Filter Toggle / Search Section
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: Theme(
                data: theme.copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: const Text(
                    'Filtros y Búsqueda',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  leading: const Icon(Icons.filter_list),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ExpensesFilters(
                        onChanged: (range, cats, search) {
                          provider.setFilters(
                            range: range,
                            categories: cats,
                            search: search,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            const Text(
              'Desglose por Día',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            if (filtered.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('No hay gastos que coincidan con los filtros.'),
                ),
              )
            else
              ...sortedKeys.map((date) {
                final gastos = grouped[date]!;
                final subtotal = gastos.fold<double>(0, (sum, e) => sum + e.amount);
                final parsedDate = DateTime.parse(date);
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('EEEE d, MMM yyyy', 'es_MX').format(parsedDate).toUpperCase(),
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              NumberFormat.simpleCurrency(locale: 'es_MX').format(subtotal),
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...gastos.map((e) => ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey.shade100,
                          child: const Icon(Icons.receipt, size: 20, color: Colors.grey),
                        ),
                        title: Text(e.description, style: const TextStyle(fontWeight: FontWeight.w500)),
                        subtitle: Text(e.category),
                        trailing: Text(
                          NumberFormat.simpleCurrency(locale: 'es_MX').format(e.amount),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(color: Colors.grey[700], fontSize: 13)),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              NumberFormat.simpleCurrency(locale: 'es_MX').format(amount),
              style: TextStyle(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
