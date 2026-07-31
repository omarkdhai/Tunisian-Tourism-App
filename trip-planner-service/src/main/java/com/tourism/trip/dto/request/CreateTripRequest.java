package com.tourism.trip.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class CreateTripRequest {

    @NotBlank(message = "Title is required")
    private String title;

    private String arrivalAirport;
    private String departureAirport;

    @NotNull(message = "Arrival date is required")
    private LocalDate arrivalDate;

    @NotNull(message = "Departure date is required")
    private LocalDate departureDate;

    private BigDecimal budget;
    private String travelStyle;
    private String preferredTransportation;
}
