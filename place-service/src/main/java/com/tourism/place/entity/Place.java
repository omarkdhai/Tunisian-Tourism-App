package com.tourism.place.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "places")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Place {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false)
    private String name;

    @Column(name = "name_ar")
    private String nameAr;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "description_ar", columnDefinition = "TEXT")
    private String descriptionAr;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private PlaceCategory category;

    @Column(nullable = false)
    private Double latitude;

    @Column(nullable = false)
    private Double longitude;

    @Column(columnDefinition = "TEXT")
    private String address;

    private String governorate;

    @Column(name = "opening_hours")
    private String openingHours;

    @Column(name = "entrance_price")
    @Builder.Default
    private BigDecimal entrancePrice = BigDecimal.ZERO;

    @Column(name = "estimated_visit_duration")
    @Builder.Default
    private Integer estimatedVisitDuration = 60;

    @Column(name = "best_time_to_visit")
    private String bestTimeToVisit;

    @Column(name = "family_friendly")
    @Builder.Default
    private Boolean familyFriendly = true;

    @Column(name = "solo_friendly")
    @Builder.Default
    private Boolean soloFriendly = true;

    @Column(name = "accessibility_info", columnDefinition = "TEXT")
    private String accessibilityInfo;

    @Column(name = "average_rating")
    @Builder.Default
    private BigDecimal averageRating = BigDecimal.ZERO;

    @Column(name = "review_count")
    @Builder.Default
    private Integer reviewCount = 0;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @OneToMany(mappedBy = "place", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<PlacePhoto> photos = new ArrayList<>();

    public enum PlaceCategory {
        BEACH, MONUMENT, CULTURE, FOOD, SAHARA, NATURE,
        ACTIVITIES, SHOPPING, NIGHTLIFE, ART, ADVENTURE
    }
}
