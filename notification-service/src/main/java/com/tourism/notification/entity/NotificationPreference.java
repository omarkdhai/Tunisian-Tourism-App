package com.tourism.notification.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "notification_preferences")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class NotificationPreference {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "user_id", nullable = false, unique = true)
    private UUID userId;

    @Column(name = "activity_reminders", nullable = false)
    @Builder.Default
    private Boolean activityReminders = true;

    @Column(name = "departure_reminders", nullable = false)
    @Builder.Default
    private Boolean departureReminders = true;

    @Column(name = "weather_alerts", nullable = false)
    @Builder.Default
    private Boolean weatherAlerts = true;

    @Column(name = "budget_alerts", nullable = false)
    @Builder.Default
    private Boolean budgetAlerts = true;

    @Column(name = "nearby_recommendations", nullable = false)
    @Builder.Default
    private Boolean nearbyRecommendations = true;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;
}
