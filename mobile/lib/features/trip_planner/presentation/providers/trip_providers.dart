import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/providers.dart';
import '../repositories/trip_repository.dart';
import '../models/trip.dart';

final tripRepositoryProvider = Provider<TripRepository>((ref) {
  final dio = ref.watch(dioClientProvider);
  return TripRepository(dio);
});

final userTripsProvider = FutureProvider<List<Trip>>((ref) async {
  final repository = ref.watch(tripRepositoryProvider);
  return repository.getUserTrips();
});

final tripDetailsProvider = FutureProvider.family<Trip, String>((ref, id) async {
  final repository = ref.watch(tripRepositoryProvider);
  return repository.getTripDetails(id);
});
