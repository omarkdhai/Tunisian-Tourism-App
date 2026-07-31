package com.tourism.place.repository;

import com.tourism.place.entity.Place;
import com.tourism.place.entity.Place.PlaceCategory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface PlaceRepository extends JpaRepository<Place, UUID> {

    Page<Place> findByCategory(PlaceCategory category, Pageable pageable);

    Page<Place> findByGovernorate(String governorate, Pageable pageable);

    @Query("SELECT p FROM Place p WHERE LOWER(p.name) LIKE LOWER(CONCAT('%', :query, '%')) " +
           "OR LOWER(p.description) LIKE LOWER(CONCAT('%', :query, '%'))")
    Page<Place> searchByNameOrDescription(@Param("query") String query, Pageable pageable);

    // PostGIS: find places within a radius (in meters)
    @Query(value = "SELECT p.* FROM places p WHERE ST_DWithin(" +
            "CAST(p.geom AS geography), CAST(ST_SetSRID(ST_MakePoint(:lon, :lat), 4326) AS geography), :radiusMeters) " +
            "ORDER BY ST_DistanceSphere(p.geom, ST_SetSRID(ST_MakePoint(:lon, :lat), 4326))",
            nativeQuery = true)
    List<Place> findNearbyPlaces(@Param("lat") double lat,
                                 @Param("lon") double lon,
                                 @Param("radiusMeters") double radiusMeters);

    // PostGIS: calculate distance between two points
    @Query(value = "SELECT ST_DistanceSphere(ST_SetSRID(ST_MakePoint(:lon1, :lat1), 4326), " +
            "ST_SetSRID(ST_MakePoint(:lon2, :lat2), 4326))",
            nativeQuery = true)
    Double calculateDistance(@Param("lat1") double lat1, @Param("lon1") double lon1,
                             @Param("lat2") double lat2, @Param("lon2") double lon2);

    // pgvector: find similar places by embedding
    @Query(value = "SELECT p.* FROM places p WHERE p.embedding IS NOT NULL " +
            "AND p.id != :placeId ORDER BY p.embedding <=> " +
            "(SELECT embedding FROM places WHERE id = :placeId) LIMIT :limit",
            nativeQuery = true)
    List<Place> findSimilarPlaces(@Param("placeId") UUID placeId, @Param("limit") int limit);

    // Get places for swipe deck (exclude already swiped)
    @Query("SELECT p FROM Place p WHERE p.id NOT IN :excludeIds ORDER BY FUNCTION('RANDOM')")
    Page<Place> findSwipeDeck(@Param("excludeIds") List<UUID> excludeIds, Pageable pageable);

    @Query("SELECT p FROM Place p ORDER BY FUNCTION('RANDOM')")
    Page<Place> findRandomPlaces(Pageable pageable);

    List<Place> findByCategoryIn(List<PlaceCategory> categories);
}
