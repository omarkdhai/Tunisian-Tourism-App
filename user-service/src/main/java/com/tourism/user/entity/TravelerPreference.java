package com.tourism.user.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "traveler_preferences")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TravelerPreference {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    private UserProfile user;

    @Column(name = "travel_style")
    private String travelStyle;

    @Column(name = "number_of_travelers")
    @Builder.Default
    private Integer numberOfTravelers = 1;

    @Enumerated(EnumType.STRING)
    @Column(name = "group_mode")
    @Builder.Default
    private GroupMode groupMode = GroupMode.SOLO;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    public enum GroupMode {
        SOLO, COUPLE, FAMILY, GROUP
    }
}
