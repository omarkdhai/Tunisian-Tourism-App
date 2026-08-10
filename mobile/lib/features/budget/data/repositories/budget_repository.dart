import 'package:dio/dio.dart';
import '../models/budget.dart';

class BudgetRepository {
  final Dio _dio;
  BudgetRepository(this._dio);

  Future<Budget> getBudget(String tripId) async {
    try {
      final response = await _dio.get('/budgets/trip/$tripId');
      return Budget.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch budget: $e');
    }
  }

  Future<void> addExpense(String tripId, Map<String, dynamic> expenseData) async {
    try {
      await _dio.post('/budgets/trip/$tripId/expenses', data: expenseData);
    } catch (e) {
      throw Exception('Failed to add expense: $e');
    }
  }
}
