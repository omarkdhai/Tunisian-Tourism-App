package com.tourism.budget.dto.response;

import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.util.UUID;

@Data
@Builder
public class BudgetCategoryResponse {
    private UUID id;
    private String category;
    private BigDecimal allocatedAmount;
    private BigDecimal spentAmount;
}
