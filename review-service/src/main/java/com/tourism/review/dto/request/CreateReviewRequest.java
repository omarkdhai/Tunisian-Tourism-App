package com.tourism.review.dto.request;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDate;
import java.util.UUID;

@Data
public class CreateReviewRequest {
    
    @NotNull(message = "Place ID is required")
    private UUID placeId;

    @NotNull(message = "Rating is required")
    @Min(1) @Max(5)
    private Double rating;

    private String comment;

    @Min(1) @Max(5)
    private Double foodRating;

    @Min(1) @Max(5)
    private Double cleanlinessRating;

    @Min(1) @Max(5)
    private Double valueRating;

    @Min(1) @Max(5)
    private Double experienceRating;

    private LocalDate visitDate;
}
