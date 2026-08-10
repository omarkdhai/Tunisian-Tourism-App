import 'package:dio/dio.dart';
import '../models/trip.dart';

class TripRepository {
  final Dio _dio;
  TripRepository(this._dio);

  Future<List<Trip>> getUserTrips() async {
    try {
      final response = await _dio.get('/trips/user');
      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((json) => Trip.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch user trips: $e');
    }
  }

  Future<Trip> getTripDetails(String id) async {
    try {
      final response = await _dio.get('/trips/$id');
      if (response.statusCode == 200) {
        return Trip.fromJson(response.data);
      }
      throw Exception('Trip not found');
    } catch (e) {
      throw Exception('Failed to fetch trip details: $e');
    }
  }

  Future<Trip> generateNewTrip(Map<String, dynamic> tripConfig) async {
    try {
      // Endpoint calling the AI generation service on Java backend
      final response = await _dio.post('/trips/generate', data: tripConfig); 
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Trip.fromJson(response.data);
      }
      throw Exception('Generate trip failed');
    } catch (e) {
      throw Exception('Failed to generate trip: $e');
    }
  }
}
