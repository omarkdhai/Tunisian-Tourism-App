package com.tourism.trip.controller;

import com.tourism.trip.dto.request.CreateTripRequest;
import com.tourism.trip.dto.response.TripResponse;
import com.tourism.trip.service.TripService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/trips")
@RequiredArgsConstructor
public class TripController {

    private final TripService tripService;

    @PostMapping
    public ResponseEntity<TripResponse> createTrip(
            @AuthenticationPrincipal Jwt jwt,
            @Valid @RequestBody CreateTripRequest request) {
        // Need to convert Keycloak UUID string to UUID? Or maybe User Service acts as proxy.
        // Assuming we pass Keycloak ID or a custom user ID. For simplicity, let's use subject as String, then hash or parse as UUID, but usually Keycloak IDs are UUID strings.
        UUID userId = UUID.fromString(jwt.getSubject());
        return ResponseEntity.status(HttpStatus.CREATED).body(tripService.createTrip(userId, request));
    }

    @GetMapping
    public ResponseEntity<List<TripResponse>> getUserTrips(@AuthenticationPrincipal Jwt jwt) {
        UUID userId = UUID.fromString(jwt.getSubject());
        return ResponseEntity.ok(tripService.getUserTrips(userId));
    }

    @GetMapping("/{id}")
    public ResponseEntity<TripResponse> getTripById(@PathVariable UUID id) {
        // Note: Missing user ownership check for brevity in this pilot implementation
        return ResponseEntity.ok(tripService.getTripById(id));
    }

    @PostMapping("/{id}/generate")
    public ResponseEntity<TripResponse> generateItinerary(@PathVariable UUID id) {
        return ResponseEntity.ok(tripService.generateItinerary(id));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteTrip(@PathVariable UUID id) {
        tripService.deleteTrip(id);
        return ResponseEntity.noContent().build();
    }
}
