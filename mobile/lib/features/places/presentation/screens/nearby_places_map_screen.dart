import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../data/models/place.dart';
import '../providers/place_providers.dart';

class NearbyPlacesMapScreen extends ConsumerStatefulWidget {
  const NearbyPlacesMapScreen({super.key});

  @override
  ConsumerState<NearbyPlacesMapScreen> createState() => _NearbyPlacesMapScreenState();
}

class _NearbyPlacesMapScreenState extends ConsumerState<NearbyPlacesMapScreen> {
  Place? _selectedPlace;
  // Default center: Tunisia
  static const LatLng _tunisiaCenter = LatLng(33.8869, 9.5375);

  // Mock places for Tunisia covering different regions
  final List<Place> _mockPlaces = [
    Place(id: '1', name: 'El Djem Amphitheatre', description: 'UNESCO World Heritage Site', category: 'MONUMENT', governorate: 'Mahdia', longitude: 10.7069, latitude: 35.2967, averageRating: 4.9, reviewCount: 380, imageUrl: 'https://images.unsplash.com/photo-1589568058-a7e4f57bc1f8?auto=format&fit=crop&w=400'),
    Place(id: '2', name: 'Djerba Beach', description: 'Tropical paradise beach', category: 'BEACH', governorate: 'Medenine', longitude: 10.8512, latitude: 33.8091, averageRating: 4.7, reviewCount: 512, imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=400'),
    Place(id: '3', name: 'Sidi Bou Said', description: 'Blue and white village', category: 'CULTURE', governorate: 'Tunis', longitude: 10.3422, latitude: 36.8703, averageRating: 4.8, reviewCount: 900, imageUrl: 'https://images.unsplash.com/photo-1574482596549-33b0fd379d74?auto=format&fit=crop&w=400'),
    Place(id: '4', name: 'Tozeur Oasis', description: 'Gateway to the Sahara', category: 'NATURE', governorate: 'Tozeur', longitude: 8.1297, latitude: 33.9197, averageRating: 4.6, reviewCount: 290, imageUrl: 'https://images.unsplash.com/photo-1509316785289-025f5b846b35?auto=format&fit=crop&w=400'),
    Place(id: '5', name: 'Medina of Tunis', description: 'Ancient walled city', category: 'CULTURE', governorate: 'Tunis', longitude: 10.1698, latitude: 36.7976, averageRating: 4.7, reviewCount: 1100, imageUrl: 'https://images.unsplash.com/photo-1591111544400-8ce2f3c5f7c2?auto=format&fit=crop&w=400'),
    Place(id: '6', name: 'Hammamet Beach', description: 'Mediterranean beach resort', category: 'BEACH', governorate: 'Nabeul', longitude: 10.6186, latitude: 36.4075, averageRating: 4.5, reviewCount: 640, imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=400'),
  ];

  final Map<String, Color> _categoryColors = {
    'MONUMENT': const Color(0xFF6C63FF),
    'BEACH': const Color(0xFF00B4D8),
    'CULTURE': const Color(0xFFFF6584),
    'NATURE': const Color(0xFF43D9A2),
    'FOOD': const Color(0xFFFFBF69),
    'ADVENTURE': const Color(0xFFFF8C42),
  };

  @override
  Widget build(BuildContext context) {
    final placesAsync = ref.watch(allPlacesProvider);

    // Use real API data if available, else fall back to mock
    final places = placesAsync.whenOrNull(data: (data) => data.isNotEmpty ? data : _mockPlaces) ?? _mockPlaces;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Stack(
        children: [
          // Full-screen Map
          FlutterMap(
            options: const MapOptions(
              initialCenter: _tunisiaCenter,
              initialZoom: 6.2,
              maxZoom: 18,
              minZoom: 4,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.tourism.mobile',
              ),
              MarkerLayer(
                markers: places.map((place) {
                  final color = _categoryColors[place.category] ?? Colors.blue;
                  return Marker(
                    point: LatLng(place.latitude, place.longitude),
                    width: 44,
                    height: 44,
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedPlace = place),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        decoration: BoxDecoration(
                          color: _selectedPlace?.id == place.id ? const Color(0xFF1E1E1E) : color,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 10, spreadRadius: 2)],
                        ),
                        child: const Icon(Icons.place, color: Colors.white, size: 20),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // Top Search Bar overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 15, offset: const Offset(0, 4))],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      const Icon(Icons.search, color: Colors.black54),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search places in Tunisia...',
                            hintStyle: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 15),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Category filter chips
          Positioned(
            top: 90,
            left: 0,
            right: 0,
            child: SafeArea(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: _categoryColors.entries.map((e) {
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: e.value,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: e.value.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 3))],
                      ),
                      child: Text(
                        e.key,
                        style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // Place detail bottom card
          if (_selectedPlace != null)
            Positioned(
              bottom: 24,
              left: 20,
              right: 20,
              child: _buildPlaceCard(_selectedPlace!),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceCard(Place place) {
    final color = _categoryColors[place.category] ?? Colors.blue;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(28)),
            child: Image.network(
              place.imageUrl,
              width: 100,
              height: 110,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(width: 100, height: 110, color: color.withOpacity(0.2)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                    child: Text(place.category, style: GoogleFonts.inter(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 6),
                  Text(place.name, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(place.governorate, style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 12)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(place.averageRating.toStringAsFixed(1), style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(width: 4),
                      Text('(${place.reviewCount})', style: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => setState(() => _selectedPlace = null),
              child: const Icon(Icons.close, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
