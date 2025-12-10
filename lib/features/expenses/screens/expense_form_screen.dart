import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/expense_provider.dart';
import '../../../core/constants/categories.dart';

import '../../../core/models/expense.dart';

class ExpenseFormScreen extends StatefulWidget {
  final Expense? initialExpense;
  const ExpenseFormScreen({super.key, this.initialExpense});

  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCategory;
  String? _selectedPaymentMethod;
  DateTime? _selectedDate;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final e = widget.initialExpense;
    if (e != null) {
      _amountController.text = e.amount.toString();
      _descriptionController.text = e.description;
      _selectedCategory = e.category;
      _selectedPaymentMethod = e.paymentMethod;
      _selectedDate = e.expenseDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final isEditing = widget.initialExpense != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Editar Gasto' : 'Agregar Gasto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Monto'),
                validator: (value) {
                  final amount = double.tryParse(value ?? '');
                  if (amount == null || amount <= 0) {
                    return 'Monto debe ser mayor a 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) => value != null && value.length >= 3
                    ? null
                    : 'Mínimo 3 caracteres',
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: categoryNames.values
                    .map(
                      (name) =>
                          DropdownMenuItem(value: name, child: Text(name)),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _selectedCategory = value),
                decoration: const InputDecoration(labelText: 'Categoría'),
                validator: (value) =>
                    value == null ? 'Selecciona una categoría' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedPaymentMethod,
                items: const [
                  DropdownMenuItem(value: 'cash', child: Text('Efectivo')),
                  DropdownMenuItem(value: 'card', child: Text('Tarjeta')),
                  DropdownMenuItem(
                    value: 'transfer',
                    child: Text('Transferencia'),
                  ),
                ],
                onChanged: (value) =>
                    setState(() => _selectedPaymentMethod = value),
                decoration: const InputDecoration(labelText: 'Método de pago'),
                validator: (value) =>
                    value == null ? 'Selecciona un método de pago' : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                  _selectedDate == null
                      ? 'Selecciona fecha'
                      : 'Fecha: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final now = DateTime.now();
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: now,
                    firstDate: DateTime(now.year - 2),
                    lastDate: DateTime(now.year + 2),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
              ),
              const SizedBox(height: 24),
              if (_loading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() &&
                        _selectedDate != null) {
                      setState(() => _loading = true);
                      bool success;
                      if (isEditing) {
                        success = await expenseProvider.updateExpense(
                          id: widget.initialExpense!.id,
                          amount: double.parse(_amountController.text),
                          description: _descriptionController.text.trim(),
                          category: _selectedCategory!,
                          paymentMethod: _selectedPaymentMethod!,
                          expenseDate: _selectedDate!,
                        );
                      } else {
                        success = await expenseProvider.addExpense(
                          amount: double.parse(_amountController.text),
                          description: _descriptionController.text.trim(),
                          category: _selectedCategory!,
                          paymentMethod: _selectedPaymentMethod!,
                          expenseDate: _selectedDate!,
                        );
                      }
                      setState(() => _loading = false);
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isEditing
                                  ? 'Gasto actualizado'
                                  : 'Gasto agregado',
                            ),
                          ),
                        );
                        if (mounted) Navigator.of(context).pop();
                      } else if (expenseProvider.errorMessage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(expenseProvider.errorMessage!),
                          ),
                        );
                      }
                    }
                  },
                  child: Text(isEditing ? 'Actualizar' : 'Guardar'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
