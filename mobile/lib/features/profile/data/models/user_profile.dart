class UserProfile {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? avatarUrl;
  final String preferredLanguage;
  final String preferredCurrency;
  final String travelerType; // SOLO, COUPLE, FAMILY, GROUP
  final int numberOfTravelers;
  final List<String> preferredCategories;
  final List<String> savedPlaceIds;

  UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.avatarUrl,
    this.preferredLanguage = 'EN',
    this.preferredCurrency = 'USD',
    this.travelerType = 'SOLO',
    this.numberOfTravelers = 1,
    this.preferredCategories = const [],
    this.savedPlaceIds = const [],
  });

  String get fullName => '$firstName $lastName';

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'],
      preferredLanguage: json['preferredLanguage'] ?? 'EN',
      preferredCurrency: json['preferredCurrency'] ?? 'USD',
      travelerType: json['travelerType'] ?? 'SOLO',
      numberOfTravelers: json['numberOfTravelers'] ?? 1,
      preferredCategories: List<String>.from(json['preferredCategories'] ?? []),
      savedPlaceIds: List<String>.from(json['savedPlaceIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'preferredLanguage': preferredLanguage,
        'preferredCurrency': preferredCurrency,
        'travelerType': travelerType,
        'numberOfTravelers': numberOfTravelers,
        'preferredCategories': preferredCategories,
      };
}
