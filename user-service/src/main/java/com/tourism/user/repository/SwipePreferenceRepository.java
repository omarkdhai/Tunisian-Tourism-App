package com.tourism.user.repository;

import com.tourism.user.entity.SwipePreference;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface SwipePreferenceRepository extends JpaRepository<SwipePreference, UUID> {
    List<SwipePreference> findByUserId(UUID userId);
    List<SwipePreference> findByUserIdAndLikedTrue(UUID userId);

    @Query("SELECT s.category, COUNT(s) FROM SwipePreference s WHERE s.user.id = :userId AND s.liked = true GROUP BY s.category ORDER BY COUNT(s) DESC")
    List<Object[]> findTopLikedCategoriesByUserId(@Param("userId") UUID userId);

    @Query("SELECT s.placeId FROM SwipePreference s WHERE s.user.id = :userId")
    List<UUID> findSwipedPlaceIdsByUserId(@Param("userId") UUID userId);
}
