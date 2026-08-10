import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/preference_swipe_screen.dart';
import '../../features/places/presentation/screens/place_details_screen.dart';
import '../../features/places/presentation/screens/nearby_places_map_screen.dart';
import '../../features/places/presentation/screens/search_screen.dart';
import '../../features/trip_planner/presentation/screens/trip_itinerary_screen.dart';
import '../../features/trip_planner/presentation/screens/trip_list_screen.dart';
import '../../features/trip_planner/presentation/screens/create_trip_screen.dart';
import '../../features/trip_planner/presentation/screens/generating_trip_screen.dart';
import '../../features/budget/presentation/screens/budget_dashboard_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_preferences_screen.dart';
import '../../features/ai_chat/presentation/screens/ai_chat_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/reviews/presentation/screens/write_review_screen.dart';
import '../../features/transportation/presentation/screens/transportation_screen.dart';
import '../../core/routing/main_scaffold.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      // ── Auth (no shell) ──
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/preference-swipe',
        name: 'preferenceSwipe',
        builder: (context, state) => const PreferenceSwipeScreen(),
      ),

      // ── Trip creation flow (no shell) ──
      GoRoute(
        path: '/create-trip',
        name: 'createTrip',
        builder: (context, state) => const CreateTripScreen(),
      ),
      GoRoute(
        path: '/generating-trip',
        name: 'generatingTrip',
        builder: (context, state) => const GeneratingTripScreen(),
      ),

      // ── Full-screen detail pages (no shell) ──
      GoRoute(
        path: '/place-details/:id',
        name: 'placeDetails',
        builder: (context, state) => const PlaceDetailsScreen(),
      ),
      GoRoute(
        path: '/trip-itinerary/:id',
        name: 'tripItinerary',
        builder: (context, state) => const TripItineraryScreen(),
      ),
      GoRoute(
        path: '/budget/:tripId',
        name: 'budget',
        builder: (context, state) =>
            BudgetDashboardScreen(tripId: state.pathParameters['tripId']!),
      ),
      GoRoute(
        path: '/write-review/:placeId',
        name: 'writeReview',
        builder: (context, state) => WriteReviewScreen(
          placeId: state.pathParameters['placeId']!,
          placeName: state.uri.queryParameters['name'] ?? 'Place',
        ),
      ),
      GoRoute(
        path: '/transportation',
        name: 'transportation',
        builder: (context, state) => TransportationScreen(
          fromLocation: state.uri.queryParameters['from'],
          toLocation: state.uri.queryParameters['to'],
        ),
      ),
      GoRoute(
        path: '/edit-preferences',
        name: 'editPreferences',
        builder: (context, state) => const EditPreferencesScreen(),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/ai-chat',
        name: 'aiChat',
        builder: (context, state) => const AiChatScreen(),
      ),

      // ── Main Shell (with bottom nav) ──
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/trips',
            name: 'trips',
            builder: (context, state) => const TripListScreen(),
          ),
          GoRoute(
            path: '/map',
            name: 'map',
            builder: (context, state) => const NearbyPlacesMapScreen(),
          ),
          GoRoute(
            path: '/search',
            name: 'search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
});
