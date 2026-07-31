package com.tourism.place.dto.response;

import lombok.Builder;
import lombok.Data;

import java.util.UUID;

@Data
@Builder
public class PlacePhotoResponse {
    private UUID id;
    private String url;
    private String caption;
    private Boolean isPrimary;
}
