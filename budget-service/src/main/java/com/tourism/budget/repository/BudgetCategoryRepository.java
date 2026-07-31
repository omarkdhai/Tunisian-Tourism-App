package com.tourism.budget.repository;

import com.tourism.budget.entity.BudgetCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface BudgetCategoryRepository extends JpaRepository<BudgetCategory, UUID> {
    Optional<BudgetCategory> findByTripBudgetIdAndCategory(UUID tripBudgetId, String category);
}
