package com.tourism.place.controller;

import com.tourism.place.dto.request.CreatePlaceRequest;
import com.tourism.place.dto.response.PlaceResponse;
import com.tourism.place.entity.Place.PlaceCategory;
import com.tourism.place.service.PlaceService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/places")
@RequiredArgsConstructor
public class PlaceController {

    private final PlaceService placeService;

    @GetMapping
    public ResponseEntity<Page<PlaceResponse>> getAllPlaces(Pageable pageable) {
        return ResponseEntity.ok(placeService.getAllPlaces(pageable));
    }

    @GetMapping("/{id}")
    public ResponseEntity<PlaceResponse> getPlaceById(@PathVariable UUID id) {
        return ResponseEntity.ok(placeService.getPlaceById(id));
    }

    @GetMapping("/category/{category}")
    public ResponseEntity<Page<PlaceResponse>> getPlacesByCategory(
            @PathVariable PlaceCategory category,
            Pageable pageable) {
        return ResponseEntity.ok(placeService.getPlacesByCategory(category, pageable));
    }

    @GetMapping("/search")
    public ResponseEntity<Page<PlaceResponse>> searchPlaces(
            @RequestParam String query,
            Pageable pageable) {
        return ResponseEntity.ok(placeService.searchPlaces(query, pageable));
    }

    @GetMapping("/nearby")
    public ResponseEntity<List<PlaceResponse>> getNearbyPlaces(
            @RequestParam double lat,
            @RequestParam double lon,
            @RequestParam(defaultValue = "5000") double radiusMeters) {
        return ResponseEntity.ok(placeService.getNearbyPlaces(lat, lon, radiusMeters));
    }

    @GetMapping("/similar/{id}")
    public ResponseEntity<List<PlaceResponse>> getSimilarPlaces(
            @PathVariable UUID id,
            @RequestParam(defaultValue = "5") int limit) {
        return ResponseEntity.ok(placeService.getSimilarPlaces(id, limit));
    }

    @GetMapping("/swipe-deck")
    public ResponseEntity<Page<PlaceResponse>> getSwipeDeck(
            @AuthenticationPrincipal Jwt jwt,
            Pageable pageable) {
        return ResponseEntity.ok(placeService.getSwipeDeck(jwt.getSubject(), pageable));
    }

    // Admin Endpoints Below

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<PlaceResponse> createPlace(@Valid @RequestBody CreatePlaceRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(placeService.createPlace(request));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<PlaceResponse> updatePlace(
            @PathVariable UUID id,
            @Valid @RequestBody CreatePlaceRequest request) {
        return ResponseEntity.ok(placeService.updatePlace(id, request));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> deletePlace(@PathVariable UUID id) {
        placeService.deletePlace(id);
        return ResponseEntity.noContent().build();
    }
}
