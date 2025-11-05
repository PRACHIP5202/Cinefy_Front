import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/booking_models.dart';
import '../services/booking_service.dart';
import '../../auth/providers/auth_providers.dart';


final bookingServiceProvider = Provider<BookingService>((_) => BookingService());


final bookingHistoryProvider = FutureProvider<List<BookingHistoryItem>>((ref) async {
  // Watch auth state to refresh when user logs in/out
  final authState = ref.watch(authStateProvider);
  
  // Only fetch if user is authenticated
  return authState.when(
    loading: () => throw Exception('Loading user data...'),
    error: (e, _) => throw Exception('Authentication error'),
    data: (user) {
      if (user == null) {
        throw Exception('Please login to view your bookings');
      }
      final svc = ref.read(bookingServiceProvider);
      return svc.history();
    },
  );
});

final bookingDetailProvider = FutureProvider.family<BookingDetail, int>((ref, bookingId) async {
  // Watch auth state to refresh when user logs in/out
  final authState = ref.watch(authStateProvider);
  
  // Only fetch if user is authenticated
  return authState.when(
    loading: () => throw Exception('Loading user data...'),
    error: (e, _) => throw Exception('Authentication error'),
    data: (user) {
      if (user == null) {
        throw Exception('Please login to view booking details');
      }
      final svc = ref.read(bookingServiceProvider);
      return svc.getBookingById(bookingId);
    },
  );
});


