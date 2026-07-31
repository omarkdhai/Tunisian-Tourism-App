package com.tourism.notification.service.impl;

import com.tourism.notification.dto.request.SendNotificationRequest;
import com.tourism.notification.dto.request.UpdatePreferenceRequest;
import com.tourism.notification.dto.response.NotificationResponse;
import com.tourism.notification.dto.response.PreferenceResponse;
import com.tourism.notification.entity.Notification;
import com.tourism.notification.entity.NotificationPreference;
import com.tourism.notification.exception.ResourceNotFoundException;
import com.tourism.notification.repository.NotificationPreferenceRepository;
import com.tourism.notification.repository.NotificationRepository;
import com.tourism.notification.service.NotificationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class NotificationServiceImpl implements NotificationService {

    private final NotificationRepository notificationRepository;
    private final NotificationPreferenceRepository preferenceRepository;

    @Override
    public NotificationResponse sendNotification(SendNotificationRequest request) {
        
        // Check preferences
        PreferenceResponse prefs = getPreferences(request.getUserId());
        boolean shouldSend = switch (request.getType()) {
            case ACTIVITY_REMINDER -> prefs.getActivityReminders();
            case DEPARTURE -> prefs.getDepartureReminders();
            case WEATHER -> prefs.getWeatherAlerts();
            case ITINERARY_CHANGE -> true; // always send
            case BUDGET_ALERT -> prefs.getBudgetAlerts();
            case NEARBY -> prefs.getNearbyRecommendations();
        };

        if (!shouldSend) {
            log.info("User {} opted out of {} notifications", request.getUserId(), request.getType());
            return null; // Or throw exception if preferred
        }

        Notification notification = Notification.builder()
                .userId(request.getUserId())
                .title(request.getTitle())
                .message(request.getMessage())
                .type(request.getType())
                .data(request.getData())
                .build();

        notification = notificationRepository.save(notification);
        log.info("Sent notification to user: {}", request.getUserId());
        
        // In a real system, you would also trigger a push notification to the mobile app here via Firebase (FCM) or APNs.

        return mapToResponse(notification);
    }

    @Override
    @Transactional(readOnly = true)
    public List<NotificationResponse> getUserNotifications(UUID userId) {
        return notificationRepository.findByUserIdOrderByCreatedAtDesc(userId)
                .stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<NotificationResponse> getUnreadNotifications(UUID userId) {
        return notificationRepository.findByUserIdAndReadFalseOrderByCreatedAtDesc(userId)
                .stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    @Override
    public void markAsRead(UUID id) {
        Notification notification = notificationRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Notification not found"));
        notification.setRead(true);
        notificationRepository.save(notification);
    }

    @Override
    public void markAllAsRead(UUID userId) {
        List<Notification> unread = notificationRepository.findByUserIdAndReadFalseOrderByCreatedAtDesc(userId);
        unread.forEach(n -> n.setRead(true));
        notificationRepository.saveAll(unread);
    }

    @Override
    public void deleteNotification(UUID id) {
        if (!notificationRepository.existsById(id)) {
            throw new ResourceNotFoundException("Notification not found");
        }
        notificationRepository.deleteById(id);
    }

    @Override
    public PreferenceResponse getPreferences(UUID userId) {
        NotificationPreference pref = preferenceRepository.findByUserId(userId)
                .orElseGet(() -> preferenceRepository.save(NotificationPreference.builder().userId(userId).build()));
        return mapToPreferenceResponse(pref);
    }

    @Override
    public PreferenceResponse updatePreferences(UUID userId, UpdatePreferenceRequest request) {
        NotificationPreference pref = preferenceRepository.findByUserId(userId)
                .orElseGet(() -> NotificationPreference.builder().userId(userId).build());

        if (request.getActivityReminders() != null) pref.setActivityReminders(request.getActivityReminders());
        if (request.getDepartureReminders() != null) pref.setDepartureReminders(request.getDepartureReminders());
        if (request.getWeatherAlerts() != null) pref.setWeatherAlerts(request.getWeatherAlerts());
        if (request.getBudgetAlerts() != null) pref.setBudgetAlerts(request.getBudgetAlerts());
        if (request.getNearbyRecommendations() != null) pref.setNearbyRecommendations(request.getNearbyRecommendations());

        pref = preferenceRepository.save(pref);
        return mapToPreferenceResponse(pref);
    }

    private NotificationResponse mapToResponse(Notification notification) {
        return NotificationResponse.builder()
                .id(notification.getId())
                .userId(notification.getUserId())
                .title(notification.getTitle())
                .message(notification.getMessage())
                .type(notification.getType())
                .read(notification.getRead())
                .data(notification.getData())
                .createdAt(notification.getCreatedAt())
                .build();
    }

    private PreferenceResponse mapToPreferenceResponse(NotificationPreference pref) {
        return PreferenceResponse.builder()
                .id(pref.getId())
                .userId(pref.getUserId())
                .activityReminders(pref.getActivityReminders())
                .departureReminders(pref.getDepartureReminders())
                .weatherAlerts(pref.getWeatherAlerts())
                .budgetAlerts(pref.getBudgetAlerts())
                .nearbyRecommendations(pref.getNearbyRecommendations())
                .build();
    }
}
