package com.tourism.budget.controller;

import com.tourism.budget.dto.request.AddExpenseRequest;
import com.tourism.budget.dto.response.ExpenseResponse;
import com.tourism.budget.dto.response.TripBudgetResponse;
import com.tourism.budget.service.BudgetService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/budget")
@RequiredArgsConstructor
public class BudgetController {

    private final BudgetService budgetService;

    @GetMapping("/trips/{tripId}")
    public ResponseEntity<TripBudgetResponse> getBudgetByTrip(@PathVariable UUID tripId) {
        return ResponseEntity.ok(budgetService.getBudgetByTrip(tripId));
    }

    @PostMapping("/trips/{tripId}")
    public ResponseEntity<TripBudgetResponse> initializeBudget(
            @AuthenticationPrincipal Jwt jwt,
            @PathVariable UUID tripId,
            @RequestParam BigDecimal totalBudget,
            @RequestParam(defaultValue = "TND") String currency) {
        UUID userId = UUID.fromString(jwt.getSubject());
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(budgetService.initializeBudget(tripId, userId, totalBudget, currency));
    }

    @PostMapping("/trips/{tripId}/expenses")
    public ResponseEntity<ExpenseResponse> addExpense(
            @PathVariable UUID tripId,
            @Valid @RequestBody AddExpenseRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(budgetService.addExpense(tripId, request));
    }

    @GetMapping("/trips/{tripId}/expenses")
    public ResponseEntity<List<ExpenseResponse>> getExpensesByTrip(@PathVariable UUID tripId) {
        return ResponseEntity.ok(budgetService.getExpensesByTrip(tripId));
    }

    @DeleteMapping("/expenses/{id}")
    public ResponseEntity<Void> deleteExpense(@PathVariable UUID id) {
        budgetService.deleteExpense(id);
        return ResponseEntity.noContent().build();
    }
}
