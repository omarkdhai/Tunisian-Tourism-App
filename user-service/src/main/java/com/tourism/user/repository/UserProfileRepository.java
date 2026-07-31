package com.tourism.user.repository;

import com.tourism.user.entity.UserProfile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface UserProfileRepository extends JpaRepository<UserProfile, UUID> {
    Optional<UserProfile> findByKeycloakId(String keycloakId);
    Optional<UserProfile> findByEmail(String email);
    boolean existsByKeycloakId(String keycloakId);
    boolean existsByEmail(String email);
}
