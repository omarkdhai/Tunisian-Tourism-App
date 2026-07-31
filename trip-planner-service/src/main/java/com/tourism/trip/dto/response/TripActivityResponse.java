package com.tourism.trip.dto.response;

import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalTime;
import java.util.UUID;

@Data
@Builder
public class TripActivityResponse {
    private UUID id;
    private UUID placeId;
    private Integer orderIndex;
    private LocalTime startTime;
    private LocalTime endTime;
    private Integer duration;
    private Integer travelTimeFromPrev;
    private Double distanceFromPrev;
    private String transportMode;
    private BigDecimal estimatedCost;
    private String status;
    private String notes;
}
