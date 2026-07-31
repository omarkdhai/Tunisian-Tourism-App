package com.tourism.trip.service;

import com.tourism.trip.dto.request.CreateTripRequest;
import com.tourism.trip.dto.response.TripResponse;

import java.util.List;
import java.util.UUID;

public interface TripService {

    TripResponse createTrip(UUID userId, CreateTripRequest request);

    List<TripResponse> getUserTrips(UUID userId);

    TripResponse getTripById(UUID id);

    void deleteTrip(UUID id);

    // AI Generation method
    TripResponse generateItinerary(UUID tripId);
}
