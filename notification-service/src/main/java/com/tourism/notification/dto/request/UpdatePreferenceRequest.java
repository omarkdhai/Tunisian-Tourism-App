package com.tourism.notification.dto.request;

import lombok.Data;

@Data
public class UpdatePreferenceRequest {
    private Boolean activityReminders;
    private Boolean departureReminders;
    private Boolean weatherAlerts;
    private Boolean budgetAlerts;
    private Boolean nearbyRecommendations;
}
