package com.tourism.trip.service.impl;

import com.tourism.trip.dto.request.CreateTripRequest;
import com.tourism.trip.dto.response.TripActivityResponse;
import com.tourism.trip.dto.response.TripDayResponse;
import com.tourism.trip.dto.response.TripResponse;
import com.tourism.trip.entity.Trip;
import com.tourism.trip.entity.TripActivity;
import com.tourism.trip.entity.TripDay;
import com.tourism.trip.exception.ResourceNotFoundException;
import com.tourism.trip.repository.TripRepository;
import com.tourism.trip.service.TripService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.temporal.ChronoUnit;
import java.util.Collections;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class TripServiceImpl implements TripService {

    private final TripRepository tripRepository;

    @Override
    public TripResponse createTrip(UUID userId, CreateTripRequest request) {
        long daysBetween = ChronoUnit.DAYS.between(request.getArrivalDate(), request.getDepartureDate()) + 1;
        int durationDays = Math.toIntExact(daysBetween);

        Trip trip = Trip.builder()
                .userId(userId)
                .title(request.getTitle())
                .arrivalAirport(request.getArrivalAirport())
                .departureAirport(request.getDepartureAirport())
                .arrivalDate(request.getArrivalDate())
                .departureDate(request.getDepartureDate())
                .durationDays(durationDays)
                .budget(request.getBudget())
                .travelStyle(request.getTravelStyle())
                .preferredTransportation(request.getPreferredTransportation())
                .build();

        trip = tripRepository.save(trip);
        log.info("Created new trip: {} for user: {}", trip.getTitle(), userId);
        return mapToResponse(trip);
    }

    @Override
    @Transactional(readOnly = true)
    public List<TripResponse> getUserTrips(UUID userId) {
        return tripRepository.findByUserId(userId)
                .stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public TripResponse getTripById(UUID id) {
        Trip trip = tripRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Trip not found with id: " + id));
        return mapToResponse(trip);
    }

    @Override
    public void deleteTrip(UUID id) {
        if (!tripRepository.existsById(id)) {
            throw new ResourceNotFoundException("Trip not found with id: " + id);
        }
        tripRepository.deleteById(id);
        log.info("Deleted trip with id: {}", id);
    }

    @Override
    public TripResponse generateItinerary(UUID tripId) {
        Trip trip = tripRepository.findById(tripId)
                .orElseThrow(() -> new ResourceNotFoundException("Trip not found with id: " + tripId));
        
        // TODO: Call AI Service (Python FastAPI) to actually generate the itinerary
        // For now, update status and return
        trip.setStatus("PLANNED");
        trip = tripRepository.save(trip);
        
        log.info("Generated itinerary for trip: {}", trip.getId());
        return mapToResponse(trip);
    }

    private TripResponse mapToResponse(Trip trip) {
        List<TripDayResponse> days = trip.getDays() != null ?
                trip.getDays().stream().map(this::mapToDayResponse).collect(Collectors.toList()) :
                Collections.emptyList();

        return TripResponse.builder()
                .id(trip.getId())
                .userId(trip.getUserId())
                .title(trip.getTitle())
                .arrivalAirport(trip.getArrivalAirport())
                .departureAirport(trip.getDepartureAirport())
                .arrivalDate(trip.getArrivalDate())
                .departureDate(trip.getDepartureDate())
                .durationDays(trip.getDurationDays())
                .budget(trip.getBudget())
                .travelStyle(trip.getTravelStyle())
                .preferredTransportation(trip.getPreferredTransportation())
                .status(trip.getStatus())
                .days(days)
                .createdAt(trip.getCreatedAt())
                .updatedAt(trip.getUpdatedAt())
                .build();
    }

    private TripDayResponse mapToDayResponse(TripDay tripDay) {
        List<TripActivityResponse> activities = tripDay.getActivities() != null ?
                tripDay.getActivities().stream().map(this::mapToActivityResponse).collect(Collectors.toList()) :
                Collections.emptyList();

        return TripDayResponse.builder()
                .id(tripDay.getId())
                .dayNumber(tripDay.getDayNumber())
                .date(tripDay.getDate())
                .estimatedCost(tripDay.getEstimatedCost())
                .notes(tripDay.getNotes())
                .activities(activities)
                .build();
    }

    private TripActivityResponse mapToActivityResponse(TripActivity activity) {
        return TripActivityResponse.builder()
                .id(activity.getId())
                .placeId(activity.getPlaceId())
                .orderIndex(activity.getOrderIndex())
                .startTime(activity.getStartTime())
                .endTime(activity.getEndTime())
                .duration(activity.getDuration())
                .travelTimeFromPrev(activity.getTravelTimeFromPrev())
                .distanceFromPrev(activity.getDistanceFromPrev())
                .transportMode(activity.getTransportMode())
                .estimatedCost(activity.getEstimatedCost())
                .status(activity.getStatus())
                .notes(activity.getNotes())
                .build();
    }
}
