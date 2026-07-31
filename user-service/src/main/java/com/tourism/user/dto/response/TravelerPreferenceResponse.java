package com.tourism.user.dto.response;

import com.tourism.user.entity.TravelerPreference.GroupMode;
import lombok.Builder;
import lombok.Data;

import java.util.UUID;

@Data
@Builder
public class TravelerPreferenceResponse {
    private UUID id;
    private String travelStyle;
    private Integer numberOfTravelers;
    private GroupMode groupMode;
}
