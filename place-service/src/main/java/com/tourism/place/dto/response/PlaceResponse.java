package com.tourism.place.dto.response;

import com.tourism.place.entity.Place.PlaceCategory;
import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
@Builder
public class PlaceResponse {
    private UUID id;
    private String name;
    private String nameAr;
    private String description;
    private String descriptionAr;
    private PlaceCategory category;
    private Double latitude;
    private Double longitude;
    private String address;
    private String governorate;
    private String openingHours;
    private BigDecimal entrancePrice;
    private Integer estimatedVisitDuration;
    private String bestTimeToVisit;
    private Boolean familyFriendly;
    private Boolean soloFriendly;
    private String accessibilityInfo;
    private BigDecimal averageRating;
    private Integer reviewCount;
    private List<PlacePhotoResponse> photos;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
