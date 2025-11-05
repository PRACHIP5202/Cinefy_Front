import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/screens/auth_gate.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/movies/screens/movie_list_screen.dart';
import '../features/movies/screens/movie_detail_screen.dart';
import '../features/theatres/screens/theatre_list_screen.dart';
import '../features/seats/screens/seat_selection_screen.dart';
import '../features/payment/screens/payment_screen.dart';
import '../features/booking/screens/booking_history_screen.dart';
import '../features/profile/screens/profile_screen.dart';


final appRouterProvider = Provider<GoRouter>((ref) {
return GoRouter(
initialLocation: '/home',
routes: [
GoRoute(path: '/gate', builder: (_, __) => const AuthGate()),
GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
GoRoute(
path: '/movie/:id',
builder: (ctx, s) => MovieDetailScreen(id: int.parse(s.pathParameters['id']!)),
),
GoRoute(
path: '/theatre-select/:movieId',
builder: (ctx, s) => TheatreListScreen(movieId: int.parse(s.pathParameters['movieId']!)),
),
GoRoute(
path: '/seat-select/:showId',
builder: (ctx, s) => SeatSelectionScreen(showId: int.parse(s.pathParameters['showId']!)),
),
GoRoute(
path: '/payment/:bookingId',
builder: (ctx, s) => PaymentScreen(bookingId: int.parse(s.pathParameters['bookingId']!)),
),
      GoRoute(
        path: '/bookings',
        builder: (ctx, s) => const BookingHistoryScreen(),
      ),
],
);
});