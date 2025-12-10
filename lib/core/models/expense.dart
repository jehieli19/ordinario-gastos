class Expense {
  final String id;
  final String userId;
  final double amount;
  final String description;
  final String category;
  final String paymentMethod;
  final DateTime expenseDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Expense({
    required this.id,
    required this.userId,
    required this.amount,
    required this.description,
    required this.category,
    required this.paymentMethod,
    required this.expenseDate,
    this.createdAt,
    this.updatedAt,
  });

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      amount: (map['amount'] as num).toDouble(),
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      paymentMethod: map['payment_method'] ?? '',
      expenseDate: DateTime.parse(map['expense_date']),
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : null,
    );
  }
}
