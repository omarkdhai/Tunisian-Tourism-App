package com.tourism.trip.dto.response;

import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Data
@Builder
public class TripDayResponse {
    private UUID id;
    private Integer dayNumber;
    private LocalDate date;
    private BigDecimal estimatedCost;
    private String notes;
    private List<TripActivityResponse> activities;
}
