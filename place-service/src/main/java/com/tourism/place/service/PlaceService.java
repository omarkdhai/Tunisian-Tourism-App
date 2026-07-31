package com.tourism.place.service;

import com.tourism.place.dto.request.CreatePlaceRequest;
import com.tourism.place.dto.response.PlaceResponse;
import com.tourism.place.entity.Place.PlaceCategory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.UUID;

public interface PlaceService {

    Page<PlaceResponse> getAllPlaces(Pageable pageable);

    PlaceResponse getPlaceById(UUID id);

    Page<PlaceResponse> getPlacesByCategory(PlaceCategory category, Pageable pageable);

    Page<PlaceResponse> searchPlaces(String query, Pageable pageable);

    List<PlaceResponse> getNearbyPlaces(double lat, double lon, double radiusMeters);

    List<PlaceResponse> getSimilarPlaces(UUID placeId, int limit);

    Page<PlaceResponse> getSwipeDeck(String keycloakId, Pageable pageable);

    PlaceResponse createPlace(CreatePlaceRequest request);

    PlaceResponse updatePlace(UUID id, CreatePlaceRequest request);

    void deletePlace(UUID id);
}
