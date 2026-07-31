package com.tourism.notification.dto.response;

import lombok.Builder;
import lombok.Data;

import java.util.UUID;

@Data
@Builder
public class PreferenceResponse {
    private UUID id;
    private UUID userId;
    private Boolean activityReminders;
    private Boolean departureReminders;
    private Boolean weatherAlerts;
    private Boolean budgetAlerts;
    private Boolean nearbyRecommendations;
}
