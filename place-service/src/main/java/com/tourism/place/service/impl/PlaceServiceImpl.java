package com.tourism.place.service.impl;

import com.tourism.place.dto.request.CreatePlaceRequest;
import com.tourism.place.dto.response.PlacePhotoResponse;
import com.tourism.place.dto.response.PlaceResponse;
import com.tourism.place.entity.Place;
import com.tourism.place.entity.Place.PlaceCategory;
import com.tourism.place.entity.PlacePhoto;
import com.tourism.place.exception.ResourceNotFoundException;
import com.tourism.place.repository.PlaceRepository;
import com.tourism.place.service.PlaceService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class PlaceServiceImpl implements PlaceService {

    private final PlaceRepository placeRepository;

    @Override
    @Transactional(readOnly = true)
    public Page<PlaceResponse> getAllPlaces(Pageable pageable) {
        return placeRepository.findAll(pageable).map(this::mapToResponse);
    }

    @Override
    @Transactional(readOnly = true)
    public PlaceResponse getPlaceById(UUID id) {
        Place place = placeRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Place not found with id: " + id));
        return mapToResponse(place);
    }

    @Override
    @Transactional(readOnly = true)
    public Page<PlaceResponse> getPlacesByCategory(PlaceCategory category, Pageable pageable) {
        return placeRepository.findByCategory(category, pageable).map(this::mapToResponse);
    }

    @Override
    @Transactional(readOnly = true)
    public Page<PlaceResponse> searchPlaces(String query, Pageable pageable) {
        return placeRepository.searchByNameOrDescription(query, pageable).map(this::mapToResponse);
    }

    @Override
    @Transactional(readOnly = true)
    public List<PlaceResponse> getNearbyPlaces(double lat, double lon, double radiusMeters) {
        return placeRepository.findNearbyPlaces(lat, lon, radiusMeters)
                .stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<PlaceResponse> getSimilarPlaces(UUID placeId, int limit) {
        if (!placeRepository.existsById(placeId)) {
            throw new ResourceNotFoundException("Place not found");
        }
        return placeRepository.findSimilarPlaces(placeId, limit)
                .stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public Page<PlaceResponse> getSwipeDeck(String keycloakId, Pageable pageable) {
        // For now, just return random places
        return placeRepository.findRandomPlaces(pageable).map(this::mapToResponse);
    }

    @Override
    public PlaceResponse createPlace(CreatePlaceRequest request) {
        Place place = Place.builder()
                .name(request.getName())
                .nameAr(request.getNameAr())
                .description(request.getDescription())
                .descriptionAr(request.getDescriptionAr())
                .category(request.getCategory())
                .latitude(request.getLatitude())
                .longitude(request.getLongitude())
                .address(request.getAddress())
                .governorate(request.getGovernorate())
                .openingHours(request.getOpeningHours())
                .entrancePrice(request.getEntrancePrice())
                .estimatedVisitDuration(request.getEstimatedVisitDuration())
                .bestTimeToVisit(request.getBestTimeToVisit())
                .familyFriendly(request.getFamilyFriendly() != null ? request.getFamilyFriendly() : true)
                .soloFriendly(request.getSoloFriendly() != null ? request.getSoloFriendly() : true)
                .accessibilityInfo(request.getAccessibilityInfo())
                .build();

        place = placeRepository.save(place);
        log.info("Created new place: {}", place.getName());
        return mapToResponse(place);
    }

    @Override
    public PlaceResponse updatePlace(UUID id, CreatePlaceRequest request) {
        Place place = placeRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Place not found with id: " + id));

        place.setName(request.getName());
        place.setNameAr(request.getNameAr());
        place.setDescription(request.getDescription());
        place.setDescriptionAr(request.getDescriptionAr());
        place.setCategory(request.getCategory());
        place.setLatitude(request.getLatitude());
        place.setLongitude(request.getLongitude());
        place.setAddress(request.getAddress());
        place.setGovernorate(request.getGovernorate());
        place.setOpeningHours(request.getOpeningHours());
        place.setEntrancePrice(request.getEntrancePrice());
        place.setEstimatedVisitDuration(request.getEstimatedVisitDuration());
        place.setBestTimeToVisit(request.getBestTimeToVisit());
        if (request.getFamilyFriendly() != null) place.setFamilyFriendly(request.getFamilyFriendly());
        if (request.getSoloFriendly() != null) place.setSoloFriendly(request.getSoloFriendly());
        place.setAccessibilityInfo(request.getAccessibilityInfo());

        place = placeRepository.save(place);
        log.info("Updated place: {}", place.getName());
        return mapToResponse(place);
    }

    @Override
    public void deletePlace(UUID id) {
        if (!placeRepository.existsById(id)) {
            throw new ResourceNotFoundException("Place not found with id: " + id);
        }
        placeRepository.deleteById(id);
        log.info("Deleted place with id: {}", id);
    }

    private PlaceResponse mapToResponse(Place place) {
        List<PlacePhotoResponse> photoResponses = place.getPhotos() != null ?
                place.getPhotos().stream().map(this::mapPhotoToResponse).collect(Collectors.toList()) :
                Collections.emptyList();

        return PlaceResponse.builder()
                .id(place.getId())
                .name(place.getName())
                .nameAr(place.getNameAr())
                .description(place.getDescription())
                .descriptionAr(place.getDescriptionAr())
                .category(place.getCategory())
                .latitude(place.getLatitude())
                .longitude(place.getLongitude())
                .address(place.getAddress())
                .governorate(place.getGovernorate())
                .openingHours(place.getOpeningHours())
                .entrancePrice(place.getEntrancePrice())
                .estimatedVisitDuration(place.getEstimatedVisitDuration())
                .bestTimeToVisit(place.getBestTimeToVisit())
                .familyFriendly(place.getFamilyFriendly())
                .soloFriendly(place.getSoloFriendly())
                .accessibilityInfo(place.getAccessibilityInfo())
                .averageRating(place.getAverageRating())
                .reviewCount(place.getReviewCount())
                .photos(photoResponses)
                .createdAt(place.getCreatedAt())
                .updatedAt(place.getUpdatedAt())
                .build();
    }

    private PlacePhotoResponse mapPhotoToResponse(PlacePhoto photo) {
        return PlacePhotoResponse.builder()
                .id(photo.getId())
                .url(photo.getUrl())
                .caption(photo.getCaption())
                .isPrimary(photo.getIsPrimary())
                .build();
    }
}
