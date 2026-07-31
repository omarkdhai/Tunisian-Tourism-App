package com.tourism.review.dto.response;

import lombok.Builder;
import lombok.Data;

import java.util.UUID;

@Data
@Builder
public class ReviewPhotoResponse {
    private UUID id;
    private String url;
    private String caption;
}
