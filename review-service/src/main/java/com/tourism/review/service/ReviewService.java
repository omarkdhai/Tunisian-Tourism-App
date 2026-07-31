package com.tourism.review.service;

import com.tourism.review.dto.request.CreateReviewRequest;
import com.tourism.review.dto.response.ReviewResponse;

import java.util.List;
import java.util.UUID;

public interface ReviewService {

    ReviewResponse createReview(UUID userId, CreateReviewRequest request);

    List<ReviewResponse> getReviewsByPlace(UUID placeId);

    List<ReviewResponse> getUserReviews(UUID userId);

    void deleteReview(UUID id, UUID userId);
}
