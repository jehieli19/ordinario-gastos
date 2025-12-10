

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/expense.dart';


class ExpenseProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<Expense> expenses = [];
  bool loading = false;
  String? errorMessage;

  // Filter State
  DateTimeRange? filterDateRange;
  Set<String> filterCategories = {};
  String filterSearch = '';

  void setFilters({
    DateTimeRange? range,
    Set<String>? categories,
    String? search,
  }) {
    if (range != null) filterDateRange = range;
    if (categories != null) filterCategories = categories;
    if (search != null) filterSearch = search;
    notifyListeners();
  }

  void clearFilters() {
    filterDateRange = null;
    filterCategories = {};
    filterSearch = '';
    notifyListeners();
  }

  List<Expense> get filteredExpenses {
    return expenses.where((e) {
      final inDate = filterDateRange == null ||
          (e.expenseDate.isAfter(
                filterDateRange!.start.subtract(const Duration(days: 1)),
              ) &&
              e.expenseDate.isBefore(
                filterDateRange!.end.add(const Duration(days: 1)),
              ));
      final inCat =
          filterCategories.isEmpty || filterCategories.contains(e.category);
      final inSearch = filterSearch.isEmpty ||
          e.description.toLowerCase().contains(filterSearch.toLowerCase());
      return inDate && inCat && inSearch;
    }).toList();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  Future<void> fetchExpenses() async {
    loading = true;
    notifyListeners();
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        expenses = [];
        loading = false;
        clearError();
        return;
      }
      final response = await _supabase
          .from('expenses')
          .select()
          .eq('user_id', user.id)
          .order('expense_date', ascending: false)
          .order('created_at', ascending: false);
      expenses = (response as List)
          .map((e) => Expense.fromMap(e as Map<String, dynamic>))
          .toList();
      clearError();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
    loading = false;
    notifyListeners();
  }

  Future<bool> addExpense({
    required double amount,
    required String description,
    required String category,
    required String paymentMethod,
    required DateTime expenseDate,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;
      await _supabase.from('expenses').insert({
        'user_id': user.id,
        'amount': amount,
        'description': description,
        'category': category,
        'payment_method': paymentMethod,
        'expense_date': expenseDate.toIso8601String().split('T').first,
      });
      await fetchExpenses();
      clearError();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateExpense({
    required String id,
    required double amount,
    required String description,
    required String category,
    required String paymentMethod,
    required DateTime expenseDate,
  }) async {
    try {
      await _supabase
          .from('expenses')
          .update({
            'amount': amount,
            'description': description,
            'category': category,
            'payment_method': paymentMethod,
            'expense_date': expenseDate.toIso8601String().split('T').first,
          })
          .eq('id', id);
      await fetchExpenses();
      clearError();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteExpense(String id) async {
    try {
      await _supabase.from('expenses').delete().eq('id', id);
      await fetchExpenses();
      clearError();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
