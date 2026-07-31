package com.tourism.budget.dto.response;

import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
public class ExpenseResponse {
    private UUID id;
    private String category;
    private String description;
    private BigDecimal amount;
    private String currency;
    private BigDecimal amountInTnd;
    private LocalDate date;
    private UUID placeId;
    private LocalDateTime createdAt;
}
