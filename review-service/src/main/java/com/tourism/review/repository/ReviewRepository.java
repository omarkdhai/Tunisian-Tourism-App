package com.tourism.review.repository;

import com.tourism.review.entity.Review;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface ReviewRepository extends JpaRepository<Review, UUID> {
    List<Review> findByPlaceId(UUID placeId);
    List<Review> findByUserId(UUID userId);
    boolean existsByUserIdAndPlaceId(UUID userId, UUID placeId);
}
