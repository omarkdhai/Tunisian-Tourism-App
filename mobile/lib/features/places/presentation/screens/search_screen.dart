import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/place.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _activeFilter = 'ALL';
  String _query = '';

  final List<Map<String, String>> _filters = [
    {'id': 'ALL', 'label': 'All', 'emoji': '✨'},
    {'id': 'BEACH', 'label': 'Beaches', 'emoji': '🏖️'},
    {'id': 'MONUMENT', 'label': 'Monuments', 'emoji': '🏛️'},
    {'id': 'CULTURE', 'label': 'Culture', 'emoji': '🕌'},
    {'id': 'FOOD', 'label': 'Food', 'emoji': '🍴'},
    {'id': 'NATURE', 'label': 'Nature', 'emoji': '🌿'},
    {'id': 'ADVENTURE', 'label': 'Adventure', 'emoji': '🧗'},
  ];

  // Mock places for search demo (real calls go to /api/places?search=query&category=filter)
  final List<Place> _allPlaces = [
    Place(id: '1', name: 'El Djem Amphitheatre', description: 'Stunning Roman Amphitheatre', category: 'MONUMENT', governorate: 'Mahdia', longitude: 10.7069, latitude: 35.2967, averageRating: 4.9, reviewCount: 380, imageUrl: 'https://images.unsplash.com/photo-1589568058-a7e4f57bc1f8?auto=format&fit=crop&w=400'),
    Place(id: '2', name: 'Djerba Beach', description: 'Mediterranean paradise', category: 'BEACH', governorate: 'Medenine', longitude: 10.8512, latitude: 33.8091, averageRating: 4.7, reviewCount: 512, imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=400'),
    Place(id: '3', name: 'Sidi Bou Said', description: 'Iconic blue and white village', category: 'CULTURE', governorate: 'Tunis', longitude: 10.3422, latitude: 36.8703, averageRating: 4.8, reviewCount: 900, imageUrl: 'https://images.unsplash.com/photo-1574482596549-33b0fd379d74?auto=format&fit=crop&w=400'),
    Place(id: '4', name: 'Tozeur Oasis', description: 'Gateway to the Sahara Desert', category: 'NATURE', governorate: 'Tozeur', longitude: 8.1297, latitude: 33.9197, averageRating: 4.6, reviewCount: 290, imageUrl: 'https://images.unsplash.com/photo-1509316785289-025f5b846b35?auto=format&fit=crop&w=400'),
    Place(id: '5', name: 'Medina of Tunis', description: 'Ancient walled city market', category: 'CULTURE', governorate: 'Tunis', longitude: 10.1698, latitude: 36.7976, averageRating: 4.7, reviewCount: 1100, imageUrl: 'https://images.unsplash.com/photo-1591111544400-8ce2f3c5f7c2?auto=format&fit=crop&w=400'),
    Place(id: '6', name: 'Hammamet Beach', description: 'Mediterranean beach resort', category: 'BEACH', governorate: 'Nabeul', longitude: 10.6186, latitude: 36.4075, averageRating: 4.5, reviewCount: 640, imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=400'),
    Place(id: '7', name: 'Ksar Ouled Soltane', description: 'Berber fortified granary', category: 'MONUMENT', governorate: 'Tataouine', longitude: 9.7592, latitude: 32.8775, averageRating: 4.8, reviewCount: 210, imageUrl: 'https://images.unsplash.com/photo-1569944991063-ab6c8f5b6a1d?auto=format&fit=crop&w=400'),
    Place(id: '8', name: 'Tabarka Coral', description: 'Scuba diving paradise', category: 'ADVENTURE', governorate: 'Jendouba', longitude: 8.7558, latitude: 36.9545, averageRating: 4.6, reviewCount: 178, imageUrl: 'https://images.unsplash.com/photo-1682687220742-aba13b6e50ba?auto=format&fit=crop&w=400'),
  ];

  List<Place> get _filteredPlaces {
    return _allPlaces.where((p) {
      final matchesCategory = _activeFilter == 'ALL' || p.category == _activeFilter;
      final matchesQuery = _query.isEmpty || p.name.toLowerCase().contains(_query.toLowerCase()) || p.governorate.toLowerCase().contains(_query.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F4F6),
        title: Text('Discover Tunisia', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 22)),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (val) => setState(() => _query = val),
                decoration: InputDecoration(
                  hintText: 'Search beaches, monuments...',
                  hintStyle: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 15),
                  prefixIcon: const Icon(Icons.search, color: Colors.black54),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(icon: const Icon(Icons.close, color: Colors.grey), onPressed: () { _searchCtrl.clear(); setState(() => _query = ''); })
                      : null,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),

          // Filter Chips
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: _filters.map((f) {
                final isActive = _activeFilter == f['id'];
                return GestureDetector(
                  onTap: () => setState(() => _activeFilter = f['id']!),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isActive ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isActive ? const Color(0xFF1E1E1E) : Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Text(f['emoji']!, style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 6),
                        Text(f['label']!,
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: isActive ? Colors.white : Colors.black87)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text('${_filteredPlaces.length} places found',
                    style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Results Grid
          Expanded(
            child: _filteredPlaces.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🔍', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 12),
                        Text('No places found', style: GoogleFonts.inter(color: Colors.grey, fontSize: 16)),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.78,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemCount: _filteredPlaces.length,
                    itemBuilder: (context, index) {
                      final place = _filteredPlaces[index];
                      return _buildPlaceCard(context, place);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceCard(BuildContext context, Place place) {
    return GestureDetector(
      onTap: () => context.push('/place-details'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                    child: Image.network(place.imageUrl, fit: BoxFit.cover, width: double.infinity,
                        errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade200)),
                  ),
                  Positioned(
                    top: 8, right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.favorite_border, size: 15),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place.name,
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(place.governorate,
                      style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 11)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: Colors.amber),
                      const SizedBox(width: 3),
                      Text(place.averageRating.toStringAsFixed(1),
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 3),
                      Text('(${place.reviewCount})',
                          style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade400)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
