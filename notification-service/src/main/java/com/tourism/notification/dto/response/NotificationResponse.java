package com.tourism.notification.dto.response;

import com.tourism.notification.entity.Notification.NotificationType;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
public class NotificationResponse {
    private UUID id;
    private UUID userId;
    private String title;
    private String message;
    private NotificationType type;
    private Boolean read;
    private String data;
    private LocalDateTime createdAt;
}
