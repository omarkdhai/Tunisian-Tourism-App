import 'package:dio/dio.dart';
import '../models/place.dart';

class PlaceRepository {
  final Dio _dio;
  PlaceRepository(this._dio);

  Future<List<Place>> getAllPlaces() async {
    try {
      final response = await _dio.get('/places');
      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((json) => Place.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch places: $e');
    }
  }

  Future<List<Place>> getPlacesByGovernorate(String governorate) async {
    try {
      final response = await _dio.get('/places/governorate/$governorate');
      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((json) => Place.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch places by governorate: $e');
    }
  }

  Future<Place> getPlaceById(String id) async {
    try {
      final response = await _dio.get('/places/$id');
      if (response.statusCode == 200) {
        return Place.fromJson(response.data);
      }
      throw Exception('Place not found');
    } catch (e) {
      throw Exception('Failed to fetch place details: $e');
    }
  }
}
