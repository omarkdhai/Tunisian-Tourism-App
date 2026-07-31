package com.tourism.user.repository;

import com.tourism.user.entity.TravelerPreference;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface TravelerPreferenceRepository extends JpaRepository<TravelerPreference, UUID> {
    Optional<TravelerPreference> findByUserId(UUID userId);
    boolean existsByUserId(UUID userId);
}
