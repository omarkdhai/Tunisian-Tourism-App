class Place {
  final String id;
  final String name;
  final String description;
  final String category;
  final String governorate;
  final double longitude;
  final double latitude;
  final double averageRating;
  final int reviewCount;
  final String imageUrl;

  Place({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.governorate,
    required this.longitude,
    required this.latitude,
    required this.averageRating,
    required this.reviewCount,
    this.imageUrl = 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?auto=format&fit=crop&q=80&w=600',
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      governorate: json['governorate'] ?? '',
      longitude: json['longitude']?.toDouble() ?? 0.0,
      latitude: json['latitude']?.toDouble() ?? 0.0,
      averageRating: json['averageRating']?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
    );
  }
}
