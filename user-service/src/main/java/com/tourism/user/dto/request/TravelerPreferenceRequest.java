package com.tourism.user.dto.request;

import com.tourism.user.entity.TravelerPreference.GroupMode;
import jakarta.validation.constraints.Min;
import lombok.Data;

@Data
public class TravelerPreferenceRequest {
    private String travelStyle;

    @Min(value = 1, message = "Number of travelers must be at least 1")
    private Integer numberOfTravelers;

    private GroupMode groupMode;
}
