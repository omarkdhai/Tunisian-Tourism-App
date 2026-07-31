package com.tourism.trip.dto.response;

import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
@Builder
public class TripResponse {
    private UUID id;
    private UUID userId;
    private String title;
    private String arrivalAirport;
    private String departureAirport;
    private LocalDate arrivalDate;
    private LocalDate departureDate;
    private Integer durationDays;
    private BigDecimal budget;
    private String travelStyle;
    private String preferredTransportation;
    private String status;
    private List<TripDayResponse> days;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
