package com.tourism.budget.service.impl;

import com.tourism.budget.dto.request.AddExpenseRequest;
import com.tourism.budget.dto.response.BudgetCategoryResponse;
import com.tourism.budget.dto.response.ExpenseResponse;
import com.tourism.budget.dto.response.TripBudgetResponse;
import com.tourism.budget.entity.BudgetCategory;
import com.tourism.budget.entity.Expense;
import com.tourism.budget.entity.TripBudget;
import com.tourism.budget.exception.DuplicateResourceException;
import com.tourism.budget.exception.ResourceNotFoundException;
import com.tourism.budget.repository.BudgetCategoryRepository;
import com.tourism.budget.repository.ExpenseRepository;
import com.tourism.budget.repository.TripBudgetRepository;
import com.tourism.budget.service.BudgetService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class BudgetServiceImpl implements BudgetService {

    private final TripBudgetRepository tripBudgetRepository;
    private final BudgetCategoryRepository budgetCategoryRepository;
    private final ExpenseRepository expenseRepository;

    @Override
    @Transactional(readOnly = true)
    public TripBudgetResponse getBudgetByTrip(UUID tripId) {
        TripBudget budget = tripBudgetRepository.findByTripId(tripId)
                .orElseThrow(() -> new ResourceNotFoundException("Budget not found for trip: " + tripId));
        return mapToResponse(budget);
    }

    @Override
    public TripBudgetResponse initializeBudget(UUID tripId, UUID userId, BigDecimal totalBudget, String currency) {
        if (tripBudgetRepository.findByTripId(tripId).isPresent()) {
            throw new DuplicateResourceException("Budget already initialized for this trip");
        }

        TripBudget budget = TripBudget.builder()
                .tripId(tripId)
                .userId(userId)
                .totalBudget(totalBudget)
                .currency(currency)
                .build();

        budget = tripBudgetRepository.save(budget);
        
        // Initialize default categories
        String[] defaultCategories = {"ACCOMMODATION", "FOOD", "TRANSPORT", "ACTIVITY", "SHOPPING", "OTHER"};
        for (String cat : defaultCategories) {
            budgetCategoryRepository.save(BudgetCategory.builder()
                    .tripBudget(budget)
                    .category(cat)
                    .build());
        }

        log.info("Initialized budget for trip: {}", tripId);
        return mapToResponse(tripBudgetRepository.findById(budget.getId()).get());
    }

    @Override
    public ExpenseResponse addExpense(UUID tripId, AddExpenseRequest request) {
        TripBudget budget = tripBudgetRepository.findByTripId(tripId)
                .orElseThrow(() -> new ResourceNotFoundException("Budget not found for trip: " + tripId));

        BudgetCategory category = budgetCategoryRepository.findByTripBudgetIdAndCategory(budget.getId(), request.getCategory())
                .orElseGet(() -> budgetCategoryRepository.save(BudgetCategory.builder()
                        .tripBudget(budget)
                        .category(request.getCategory())
                        .build()));

        // In a real app, integrate with Exchange Rate API. For now, assume TND or 1:1 if matching.
        BigDecimal amountInTnd = request.getAmount(); 

        Expense expense = Expense.builder()
                .tripBudget(budget)
                .category(category)
                .description(request.getDescription())
                .amount(request.getAmount())
                .currency(request.getCurrency())
                .amountInTnd(amountInTnd)
                .date(request.getDate())
                .placeId(request.getPlaceId())
                .build();

        expense = expenseRepository.save(expense);
        
        // Update category spent amount
        category.setSpentAmount(category.getSpentAmount().add(amountInTnd));
        budgetCategoryRepository.save(category);

        log.info("Added expense to trip: {}", tripId);
        return mapToExpenseResponse(expense);
    }

    @Override
    @Transactional(readOnly = true)
    public List<ExpenseResponse> getExpensesByTrip(UUID tripId) {
        TripBudget budget = tripBudgetRepository.findByTripId(tripId)
                .orElseThrow(() -> new ResourceNotFoundException("Budget not found for trip: " + tripId));
        return expenseRepository.findByTripBudgetId(budget.getId())
                .stream()
                .map(this::mapToExpenseResponse)
                .collect(Collectors.toList());
    }

    @Override
    public void deleteExpense(UUID expenseId) {
        Expense expense = expenseRepository.findById(expenseId)
                .orElseThrow(() -> new ResourceNotFoundException("Expense not found"));
        
        BudgetCategory category = expense.getCategory();
        category.setSpentAmount(category.getSpentAmount().subtract(expense.getAmountInTnd()));
        budgetCategoryRepository.save(category);
        
        expenseRepository.delete(expense);
        log.info("Deleted expense: {}", expenseId);
    }

    private TripBudgetResponse mapToResponse(TripBudget budget) {
        List<BudgetCategoryResponse> categories = budget.getCategories() != null ?
                budget.getCategories().stream().map(this::mapToCategoryResponse).collect(Collectors.toList()) :
                Collections.emptyList();

        BigDecimal totalSpent = categories.stream()
                .map(BudgetCategoryResponse::getSpentAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal remainingBudget = budget.getTotalBudget().subtract(totalSpent);

        return TripBudgetResponse.builder()
                .id(budget.getId())
                .tripId(budget.getTripId())
                .totalBudget(budget.getTotalBudget())
                .currency(budget.getCurrency())
                .totalSpent(totalSpent)
                .remainingBudget(remainingBudget)
                .categories(categories)
                .updatedAt(budget.getUpdatedAt())
                .build();
    }

    private BudgetCategoryResponse mapToCategoryResponse(BudgetCategory category) {
        return BudgetCategoryResponse.builder()
                .id(category.getId())
                .category(category.getCategory())
                .allocatedAmount(category.getAllocatedAmount())
                .spentAmount(category.getSpentAmount())
                .build();
    }

    private ExpenseResponse mapToExpenseResponse(Expense expense) {
        return ExpenseResponse.builder()
                .id(expense.getId())
                .category(expense.getCategory().getCategory())
                .description(expense.getDescription())
                .amount(expense.getAmount())
                .currency(expense.getCurrency())
                .amountInTnd(expense.getAmountInTnd())
                .date(expense.getDate())
                .placeId(expense.getPlaceId())
                .createdAt(expense.getCreatedAt())
                .build();
    }
}
