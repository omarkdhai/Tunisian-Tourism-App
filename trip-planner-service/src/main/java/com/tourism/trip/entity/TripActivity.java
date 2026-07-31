package com.tourism.trip.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalTime;
import java.util.UUID;

@Entity
@Table(name = "trip_activities")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TripActivity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "trip_day_id", nullable = false)
    private TripDay tripDay;

    @Column(name = "place_id", nullable = false)
    private UUID placeId;

    @Column(name = "order_index", nullable = false)
    private Integer orderIndex;

    @Column(name = "start_time")
    private LocalTime startTime;

    @Column(name = "end_time")
    private LocalTime endTime;

    @Column(nullable = false)
    private Integer duration;

    @Column(name = "travel_time_from_prev")
    private Integer travelTimeFromPrev;

    @Column(name = "distance_from_prev")
    private Double distanceFromPrev;

    @Column(name = "transport_mode")
    private String transportMode;

    @Column(name = "estimated_cost")
    @Builder.Default
    private BigDecimal estimatedCost = BigDecimal.ZERO;

    @Column(nullable = false)
    @Builder.Default
    private String status = "PLANNED";

    @Column(columnDefinition = "TEXT")
    private String notes;
}
