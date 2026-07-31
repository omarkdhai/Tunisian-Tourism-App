package com.tourism.place.dto.request;

import com.tourism.place.entity.Place.PlaceCategory;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class CreatePlaceRequest {

    @NotBlank(message = "Name is required")
    private String name;

    private String nameAr;

    private String description;
    private String descriptionAr;

    @NotNull(message = "Category is required")
    private PlaceCategory category;

    @NotNull(message = "Latitude is required")
    private Double latitude;

    @NotNull(message = "Longitude is required")
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
}
