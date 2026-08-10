class Budget {
  final String id;
  final String tripId;
  final double totalBudget;
  final double totalSpent;
  final String currency;
  final List<Expense> expenses;

  Budget({
    required this.id,
    required this.tripId,
    required this.totalBudget,
    required this.totalSpent,
    required this.currency,
    required this.expenses,
  });

  double get remaining => totalBudget - totalSpent;
  double get spentPercent => totalBudget > 0 ? (totalSpent / totalBudget).clamp(0.0, 1.0) : 0;

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'] ?? '',
      tripId: json['tripId'] ?? '',
      totalBudget: json['totalBudget']?.toDouble() ?? 0.0,
      totalSpent: json['totalSpent']?.toDouble() ?? 0.0,
      currency: json['currency'] ?? 'USD',
      expenses: (json['expenses'] as List?)?.map((e) => Expense.fromJson(e)).toList() ?? [],
    );
  }
}

class Expense {
  final String id;
  final String description;
  final double amount;
  final String category; // ACCOMMODATION, FOOD, TRANSPORT, ACTIVITY, OTHER
  final DateTime date;

  Expense({
    required this.id,
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] ?? '',
      description: json['description'] ?? '',
      amount: json['amount']?.toDouble() ?? 0.0,
      category: json['category'] ?? 'OTHER',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
    );
  }
}
