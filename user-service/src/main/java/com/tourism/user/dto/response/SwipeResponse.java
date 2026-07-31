package com.tourism.user.dto.response;

import com.tourism.user.entity.SwipePreference.PlaceCategory;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
public class SwipeResponse {
    private UUID id;
    private PlaceCategory category;
    private Boolean liked;
    private UUID placeId;
    private Integer intensity;
    private LocalDateTime createdAt;
}
