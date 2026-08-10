import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/providers.dart';
import '../repositories/place_repository.dart';
import '../models/place.dart';

final placeRepositoryProvider = Provider<PlaceRepository>((ref) {
  final dio = ref.watch(dioClientProvider);
  return PlaceRepository(dio);
});

final allPlacesProvider = FutureProvider<List<Place>>((ref) async {
  final repository = ref.watch(placeRepositoryProvider);
  return repository.getAllPlaces();
});

final placesByLocationProvider = FutureProvider.family<List<Place>, String>((ref, governorate) async {
  final repository = ref.watch(placeRepositoryProvider);
  if (governorate.isEmpty || governorate == 'All') {
     return repository.getAllPlaces(); 
  }
  return repository.getPlacesByGovernorate(governorate);
});

final placeDetailsProvider = FutureProvider.family<Place, String>((ref, id) async {
  final repository = ref.watch(placeRepositoryProvider);
  return repository.getPlaceById(id);
});
