import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/providers.dart';
import '../../data/repositories/budget_repository.dart';
import '../../data/models/budget.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepository(ref.watch(dioClientProvider));
});

final budgetProvider = FutureProvider.family<Budget, String>((ref, tripId) async {
  return ref.watch(budgetRepositoryProvider).getBudget(tripId);
});
