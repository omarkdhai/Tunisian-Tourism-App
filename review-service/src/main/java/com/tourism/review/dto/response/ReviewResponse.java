package com.tourism.review.dto.response;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
@Builder
public class ReviewResponse {
    private UUID id;
    private UUID userId;
    private UUID placeId;
    private Double rating;
    private String comment;
    private Double foodRating;
    private Double cleanlinessRating;
    private Double valueRating;
    private Double experienceRating;
    private LocalDate visitDate;
    private List<ReviewPhotoResponse> photos;
    private LocalDateTime createdAt;
}
