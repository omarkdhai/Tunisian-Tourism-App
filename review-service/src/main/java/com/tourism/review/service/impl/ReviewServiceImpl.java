package com.tourism.review.service.impl;

import com.tourism.review.dto.request.CreateReviewRequest;
import com.tourism.review.dto.response.ReviewPhotoResponse;
import com.tourism.review.dto.response.ReviewResponse;
import com.tourism.review.entity.Review;
import com.tourism.review.entity.ReviewPhoto;
import com.tourism.review.exception.DuplicateResourceException;
import com.tourism.review.exception.ResourceNotFoundException;
import com.tourism.review.repository.ReviewRepository;
import com.tourism.review.service.ReviewService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class ReviewServiceImpl implements ReviewService {

    private final ReviewRepository reviewRepository;

    @Override
    public ReviewResponse createReview(UUID userId, CreateReviewRequest request) {
        if (reviewRepository.existsByUserIdAndPlaceId(userId, request.getPlaceId())) {
            throw new DuplicateResourceException("You have already reviewed this place");
        }

        Review review = Review.builder()
                .userId(userId)
                .placeId(request.getPlaceId())
                .rating(request.getRating())
                .comment(request.getComment())
                .foodRating(request.getFoodRating())
                .cleanlinessRating(request.getCleanlinessRating())
                .valueRating(request.getValueRating())
                .experienceRating(request.getExperienceRating())
                .visitDate(request.getVisitDate())
                .build();

        review = reviewRepository.save(review);
        log.info("Created review for place: {} by user: {}", request.getPlaceId(), userId);
        return mapToResponse(review);
    }

    @Override
    @Transactional(readOnly = true)
    public List<ReviewResponse> getReviewsByPlace(UUID placeId) {
        return reviewRepository.findByPlaceId(placeId)
                .stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<ReviewResponse> getUserReviews(UUID userId) {
        return reviewRepository.findByUserId(userId)
                .stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    @Override
    public void deleteReview(UUID id, UUID userId) {
        Review review = reviewRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Review not found with id: " + id));
        
        if (!review.getUserId().equals(userId)) {
            throw new RuntimeException("Unauthorized to delete this review");
        }
        
        reviewRepository.delete(review);
        log.info("Deleted review with id: {}", id);
    }

    private ReviewResponse mapToResponse(Review review) {
        List<ReviewPhotoResponse> photos = review.getPhotos() != null ?
                review.getPhotos().stream().map(this::mapToPhotoResponse).collect(Collectors.toList()) :
                Collections.emptyList();

        return ReviewResponse.builder()
                .id(review.getId())
                .userId(review.getUserId())
                .placeId(review.getPlaceId())
                .rating(review.getRating())
                .comment(review.getComment())
                .foodRating(review.getFoodRating())
                .cleanlinessRating(review.getCleanlinessRating())
                .valueRating(review.getValueRating())
                .experienceRating(review.getExperienceRating())
                .visitDate(review.getVisitDate())
                .photos(photos)
                .createdAt(review.getCreatedAt())
                .build();
    }

    private ReviewPhotoResponse mapToPhotoResponse(ReviewPhoto photo) {
        return ReviewPhotoResponse.builder()
                .id(photo.getId())
                .url(photo.getUrl())
                .caption(photo.getCaption())
                .build();
    }
}
