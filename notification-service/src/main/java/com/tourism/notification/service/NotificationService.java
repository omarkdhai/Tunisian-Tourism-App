package com.tourism.notification.service;

import com.tourism.notification.dto.request.SendNotificationRequest;
import com.tourism.notification.dto.request.UpdatePreferenceRequest;
import com.tourism.notification.dto.response.NotificationResponse;
import com.tourism.notification.dto.response.PreferenceResponse;

import java.util.List;
import java.util.UUID;

public interface NotificationService {

    NotificationResponse sendNotification(SendNotificationRequest request);

    List<NotificationResponse> getUserNotifications(UUID userId);

    List<NotificationResponse> getUnreadNotifications(UUID userId);

    void markAsRead(UUID id);

    void markAllAsRead(UUID userId);

    void deleteNotification(UUID id);

    PreferenceResponse getPreferences(UUID userId);

    PreferenceResponse updatePreferences(UUID userId, UpdatePreferenceRequest request);
}
