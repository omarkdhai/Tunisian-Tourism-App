import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../providers/trip_providers.dart';

class TripListScreen extends ConsumerWidget {
  const TripListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsync = ref.watch(userTripsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text('My Trips', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFF3F4F6),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: Color(0xFF1E1E1E), size: 28),
            onPressed: () {
               context.push('/create-trip');
            },
          )
        ],
      ),
      body: tripsAsync.when(
        data: (trips) {
          if (trips.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.flight_takeoff, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text('No trips planned yet.', style: GoogleFonts.inter(color: Colors.grey.shade600)),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 100),
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final trip = trips[index];
              return GestureDetector(
                onTap: () => context.pushNamed('tripItinerary', pathParameters: {'id': trip.id}),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    image: DecorationImage(
                      image: NetworkImage(trip.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trip.title,
                              style: GoogleFonts.inter(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${trip.days.length} Days • ${trip.status}',
                              style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
