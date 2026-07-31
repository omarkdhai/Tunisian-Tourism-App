package com.tourism.budget.repository;

import com.tourism.budget.entity.TripBudget;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface TripBudgetRepository extends JpaRepository<TripBudget, UUID> {
    Optional<TripBudget> findByTripId(UUID tripId);
}
