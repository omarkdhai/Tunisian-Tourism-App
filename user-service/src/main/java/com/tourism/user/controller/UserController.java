package com.tourism.user.controller;

import com.tourism.user.dto.request.*;
import com.tourism.user.dto.response.*;
import com.tourism.user.service.UserService;
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
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @PostMapping("/register")
    public ResponseEntity<UserProfileResponse> register(@Valid @RequestBody RegisterRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(userService.register(request));
    }

    @GetMapping("/me")
    public ResponseEntity<UserProfileResponse> getCurrentUser(@AuthenticationPrincipal Jwt jwt) {
        return ResponseEntity.ok(userService.getCurrentUser(jwt.getSubject()));
    }

    @PutMapping("/me")
    public ResponseEntity<UserProfileResponse> updateProfile(
            @AuthenticationPrincipal Jwt jwt,
            @Valid @RequestBody UpdateProfileRequest request) {
        return ResponseEntity.ok(userService.updateProfile(jwt.getSubject(), request));
    }

    @PostMapping("/me/preferences")
    public ResponseEntity<TravelerPreferenceResponse> savePreferences(
            @AuthenticationPrincipal Jwt jwt,
            @Valid @RequestBody TravelerPreferenceRequest request) {
        return ResponseEntity.ok(userService.savePreferences(jwt.getSubject(), request));
    }

    @GetMapping("/me/preferences")
    public ResponseEntity<TravelerPreferenceResponse> getPreferences(@AuthenticationPrincipal Jwt jwt) {
        return ResponseEntity.ok(userService.getPreferences(jwt.getSubject()));
    }

    @PostMapping("/me/swipes")
    public ResponseEntity<List<SwipeResponse>> recordSwipes(
            @AuthenticationPrincipal Jwt jwt,
            @Valid @RequestBody List<SwipeRequest> swipes) {
        return ResponseEntity.status(HttpStatus.CREATED).body(userService.recordSwipes(jwt.getSubject(), swipes));
    }

    @GetMapping("/me/swipes")
    public ResponseEntity<List<SwipeResponse>> getSwipeHistory(@AuthenticationPrincipal Jwt jwt) {
        return ResponseEntity.ok(userService.getSwipeHistory(jwt.getSubject()));
    }

    @PostMapping("/me/saved-places/{placeId}")
    public ResponseEntity<Void> savePlace(
            @AuthenticationPrincipal Jwt jwt,
            @PathVariable UUID placeId) {
        userService.savePlace(jwt.getSubject(), placeId);
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }

    @GetMapping("/me/saved-places")
    public ResponseEntity<List<UUID>> getSavedPlaces(@AuthenticationPrincipal Jwt jwt) {
        return ResponseEntity.ok(userService.getSavedPlaces(jwt.getSubject()));
    }

    @DeleteMapping("/me/saved-places/{placeId}")
    public ResponseEntity<Void> removeSavedPlace(
            @AuthenticationPrincipal Jwt jwt,
            @PathVariable UUID placeId) {
        userService.removeSavedPlace(jwt.getSubject(), placeId);
        return ResponseEntity.noContent().build();
    }
}
