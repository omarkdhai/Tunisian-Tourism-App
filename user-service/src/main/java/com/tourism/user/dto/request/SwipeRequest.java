package com.tourism.user.dto.request;

import com.tourism.user.entity.SwipePreference.PlaceCategory;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.UUID;

@Data
public class SwipeRequest {

    @NotNull(message = "Category is required")
    private PlaceCategory category;

    @NotNull(message = "Liked status is required")
    private Boolean liked;

    private UUID placeId;

    private Integer intensity;
}
