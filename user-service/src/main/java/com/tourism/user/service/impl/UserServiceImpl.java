package com.tourism.user.service.impl;

import com.tourism.user.dto.request.*;
import com.tourism.user.dto.response.*;
import com.tourism.user.entity.*;
import com.tourism.user.exception.ResourceNotFoundException;
import com.tourism.user.exception.DuplicateResourceException;
import com.tourism.user.repository.*;
import com.tourism.user.service.UserService;
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
public class UserServiceImpl implements UserService {

    private final UserProfileRepository userProfileRepository;
    private final TravelerPreferenceRepository travelerPreferenceRepository;
    private final SwipePreferenceRepository swipePreferenceRepository;
    private final SavedPlaceRepository savedPlaceRepository;

    @Override
    public UserProfileResponse register(RegisterRequest request) {
        if (userProfileRepository.existsByKeycloakId(request.getKeycloakId())) {
            throw new DuplicateResourceException("User already registered with this Keycloak ID");
        }
        if (userProfileRepository.existsByEmail(request.getEmail())) {
            throw new DuplicateResourceException("User already registered with this email");
        }

        UserProfile profile = UserProfile.builder()
                .keycloakId(request.getKeycloakId())
                .email(request.getEmail())
                .firstName(request.getFirstName())
                .lastName(request.getLastName())
                .profileImageUrl(request.getProfileImageUrl())
                .preferredLanguage(request.getPreferredLanguage() != null ? request.getPreferredLanguage() : "en")
                .preferredCurrency(request.getPreferredCurrency() != null ? request.getPreferredCurrency() : "TND")
                .build();

        profile = userProfileRepository.save(profile);
        log.info("Registered new user: {}", profile.getEmail());
        return mapToResponse(profile);
    }

    @Override
    @Transactional(readOnly = true)
    public UserProfileResponse getCurrentUser(String keycloakId) {
        UserProfile profile = findByKeycloakId(keycloakId);
        return mapToResponse(profile);
    }

    @Override
    public UserProfileResponse updateProfile(String keycloakId, UpdateProfileRequest request) {
        UserProfile profile = findByKeycloakId(keycloakId);

        if (request.getFirstName() != null) profile.setFirstName(request.getFirstName());
        if (request.getLastName() != null) profile.setLastName(request.getLastName());
        if (request.getProfileImageUrl() != null) profile.setProfileImageUrl(request.getProfileImageUrl());
        if (request.getPreferredLanguage() != null) profile.setPreferredLanguage(request.getPreferredLanguage());
        if (request.getPreferredCurrency() != null) profile.setPreferredCurrency(request.getPreferredCurrency());

        profile = userProfileRepository.save(profile);
        log.info("Updated profile for user: {}", profile.getEmail());
        return mapToResponse(profile);
    }

    @Override
    public TravelerPreferenceResponse savePreferences(String keycloakId, TravelerPreferenceRequest request) {
        UserProfile profile = findByKeycloakId(keycloakId);

        TravelerPreference preference = travelerPreferenceRepository.findByUserId(profile.getId())
                .orElse(TravelerPreference.builder().user(profile).build());

        if (request.getTravelStyle() != null) preference.setTravelStyle(request.getTravelStyle());
        if (request.getNumberOfTravelers() != null) preference.setNumberOfTravelers(request.getNumberOfTravelers());
        if (request.getGroupMode() != null) preference.setGroupMode(request.getGroupMode());

        preference = travelerPreferenceRepository.save(preference);
        log.info("Saved traveler preferences for user: {}", profile.getEmail());
        return mapToPreferenceResponse(preference);
    }

    @Override
    @Transactional(readOnly = true)
    public TravelerPreferenceResponse getPreferences(String keycloakId) {
        UserProfile profile = findByKeycloakId(keycloakId);
        TravelerPreference preference = travelerPreferenceRepository.findByUserId(profile.getId())
                .orElseThrow(() -> new ResourceNotFoundException("Traveler preferences not found"));
        return mapToPreferenceResponse(preference);
    }

    @Override
    public List<SwipeResponse> recordSwipes(String keycloakId, List<SwipeRequest> swipes) {
        UserProfile profile = findByKeycloakId(keycloakId);

        List<SwipePreference> preferences = swipes.stream()
                .map(swipe -> SwipePreference.builder()
                        .user(profile)
                        .category(swipe.getCategory())
                        .liked(swipe.getLiked())
                        .placeId(swipe.getPlaceId())
                        .intensity(swipe.getIntensity() != null ? swipe.getIntensity() : 3)
                        .build())
                .collect(Collectors.toList());

        preferences = swipePreferenceRepository.saveAll(preferences);
        log.info("Recorded {} swipes for user: {}", swipes.size(), profile.getEmail());
        return preferences.stream().map(this::mapToSwipeResponse).collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<SwipeResponse> getSwipeHistory(String keycloakId) {
        UserProfile profile = findByKeycloakId(keycloakId);
        return swipePreferenceRepository.findByUserId(profile.getId())
                .stream()
                .map(this::mapToSwipeResponse)
                .collect(Collectors.toList());
    }

    @Override
    public void savePlace(String keycloakId, UUID placeId) {
        UserProfile profile = findByKeycloakId(keycloakId);

        if (savedPlaceRepository.existsByUserIdAndPlaceId(profile.getId(), placeId)) {
            throw new DuplicateResourceException("Place already saved");
        }

        SavedPlace savedPlace = SavedPlace.builder()
                .user(profile)
                .placeId(placeId)
                .build();
        savedPlaceRepository.save(savedPlace);
        log.info("User {} saved place {}", profile.getEmail(), placeId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<UUID> getSavedPlaces(String keycloakId) {
        UserProfile profile = findByKeycloakId(keycloakId);
        return savedPlaceRepository.findByUserId(profile.getId())
                .stream()
                .map(SavedPlace::getPlaceId)
                .collect(Collectors.toList());
    }

    @Override
    public void removeSavedPlace(String keycloakId, UUID placeId) {
        UserProfile profile = findByKeycloakId(keycloakId);
        savedPlaceRepository.deleteByUserIdAndPlaceId(profile.getId(), placeId);
        log.info("User {} removed saved place {}", profile.getEmail(), placeId);
    }

    // --- Helpers ---

    private UserProfile findByKeycloakId(String keycloakId) {
        return userProfileRepository.findByKeycloakId(keycloakId)
                .orElseThrow(() -> new ResourceNotFoundException("User profile not found"));
    }

    private UserProfileResponse mapToResponse(UserProfile profile) {
        return UserProfileResponse.builder()
                .id(profile.getId())
                .keycloakId(profile.getKeycloakId())
                .email(profile.getEmail())
                .firstName(profile.getFirstName())
                .lastName(profile.getLastName())
                .profileImageUrl(profile.getProfileImageUrl())
                .preferredLanguage(profile.getPreferredLanguage())
                .preferredCurrency(profile.getPreferredCurrency())
                .createdAt(profile.getCreatedAt())
                .updatedAt(profile.getUpdatedAt())
                .build();
    }

    private TravelerPreferenceResponse mapToPreferenceResponse(TravelerPreference pref) {
        return TravelerPreferenceResponse.builder()
                .id(pref.getId())
                .travelStyle(pref.getTravelStyle())
                .numberOfTravelers(pref.getNumberOfTravelers())
                .groupMode(pref.getGroupMode())
                .build();
    }

    private SwipeResponse mapToSwipeResponse(SwipePreference swipe) {
        return SwipeResponse.builder()
                .id(swipe.getId())
                .category(swipe.getCategory())
                .liked(swipe.getLiked())
                .placeId(swipe.getPlaceId())
                .intensity(swipe.getIntensity())
                .createdAt(swipe.getCreatedAt())
                .build();
    }
}
