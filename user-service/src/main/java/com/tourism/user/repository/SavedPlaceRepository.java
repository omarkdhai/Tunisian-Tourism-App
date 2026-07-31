package com.tourism.user.repository;

import com.tourism.user.entity.SavedPlace;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface SavedPlaceRepository extends JpaRepository<SavedPlace, UUID> {
    List<SavedPlace> findByUserId(UUID userId);
    Optional<SavedPlace> findByUserIdAndPlaceId(UUID userId, UUID placeId);
    boolean existsByUserIdAndPlaceId(UUID userId, UUID placeId);
    void deleteByUserIdAndPlaceId(UUID userId, UUID placeId);
}
