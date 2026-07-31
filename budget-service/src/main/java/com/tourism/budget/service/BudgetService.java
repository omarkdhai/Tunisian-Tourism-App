package com.tourism.budget.service;

import com.tourism.budget.dto.request.AddExpenseRequest;
import com.tourism.budget.dto.response.ExpenseResponse;
import com.tourism.budget.dto.response.TripBudgetResponse;

import java.util.List;
import java.util.UUID;

public interface BudgetService {

    TripBudgetResponse getBudgetByTrip(UUID tripId);

    TripBudgetResponse initializeBudget(UUID tripId, UUID userId, java.math.BigDecimal totalBudget, String currency);

    ExpenseResponse addExpense(UUID tripId, AddExpenseRequest request);

    List<ExpenseResponse> getExpensesByTrip(UUID tripId);

    void deleteExpense(UUID expenseId);
}
