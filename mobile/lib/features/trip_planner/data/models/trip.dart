class TripActivity {
  final String id;
  final String title;
  final String description;
  final String timeOfDay; // Morning, Afternoon, Evening
  final String placeId;
  final int sequenceOrder;
  final double estimatedCost;

  TripActivity({
    required this.id,
    required this.title,
    required this.description,
    required this.timeOfDay,
    required this.placeId,
    required this.sequenceOrder,
    required this.estimatedCost,
  });

  factory TripActivity.fromJson(Map<String, dynamic> json) {
    return TripActivity(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      timeOfDay: json['timeOfDay'] ?? 'Morning',
      placeId: json['placeId'] ?? '',
      sequenceOrder: json['sequenceOrder'] ?? 0,
      estimatedCost: json['estimatedCost']?.toDouble() ?? 0.0,
    );
  }
}

class TripDay {
  final String id;
  final int dayIndex;
  final DateTime date;
  final String title;
  final List<TripActivity> activities;

  TripDay({
    required this.id,
    required this.dayIndex,
    required this.date,
    required this.title,
    required this.activities,
  });

  factory TripDay.fromJson(Map<String, dynamic> json) {
    return TripDay(
      id: json['id'] ?? '',
      dayIndex: json['dayIndex'] ?? 1,
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      title: json['title'] ?? '',
      activities: (json['activities'] as List?)
              ?.map((item) => TripActivity.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class Trip {
  final String id;
  final String userId;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final double totalBudget;
  final String airportCode;
  final String status;
  final List<TripDay> days;
  final String imageUrl; // For UI rendering

  Trip({
    required this.id,
    required this.userId,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.totalBudget,
    required this.airportCode,
    required this.status,
    required this.days,
    this.imageUrl = 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?auto=format&fit=crop&w=400',
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : DateTime.now(),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : DateTime.now(),
      totalBudget: json['totalBudget']?.toDouble() ?? 0.0,
      airportCode: json['airportCode'] ?? '',
      status: json['status'] ?? 'PLANNED',
      days: (json['days'] as List?)?.map((item) => TripDay.fromJson(item)).toList() ?? [],
    );
  }
}
