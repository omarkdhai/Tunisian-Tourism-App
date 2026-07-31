package com.tourism.user.service;

import com.tourism.user.dto.request.*;
import com.tourism.user.dto.response.*;

import java.util.List;
import java.util.UUID;

public interface UserService {

    UserProfileResponse register(RegisterRequest request);

    UserProfileResponse getCurrentUser(String keycloakId);

    UserProfileResponse updateProfile(String keycloakId, UpdateProfileRequest request);

    TravelerPreferenceResponse savePreferences(String keycloakId, TravelerPreferenceRequest request);

    TravelerPreferenceResponse getPreferences(String keycloakId);

    List<SwipeResponse> recordSwipes(String keycloakId, List<SwipeRequest> swipes);

    List<SwipeResponse> getSwipeHistory(String keycloakId);

    void savePlace(String keycloakId, UUID placeId);

    List<UUID> getSavedPlaces(String keycloakId);

    void removeSavedPlace(String keycloakId, UUID placeId);
}
