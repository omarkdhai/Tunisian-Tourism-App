package com.tourism.budget.dto.response;

import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
@Builder
public class TripBudgetResponse {
    private UUID id;
    private UUID tripId;
    private BigDecimal totalBudget;
    private String currency;
    private BigDecimal totalSpent;
    private BigDecimal remainingBudget;
    private List<BudgetCategoryResponse> categories;
    private LocalDateTime updatedAt;
}
