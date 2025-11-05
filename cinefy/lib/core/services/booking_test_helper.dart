import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_helper.dart';
import '../../features/booking/providers/booking_providers.dart';
import '../../features/auth/providers/auth_providers.dart';

/// Helper class to test booking functionality and auth integration
class BookingTestHelper {
  /// Test if user can access booking history
  static Future<String> testBookingHistoryAccess(WidgetRef ref) async {
    try {
      // Check if user is authenticated
      final isAuth = await AuthHelper.isAuthenticated();
      if (!isAuth) {
        return 'FAIL: User not authenticated';
      }

      // Try to fetch booking history
      final history = await ref.read(bookingHistoryProvider.future);
      return 'PASS: Successfully fetched ${history.length} bookings';
    } catch (e) {
      if (e.toString().contains('login')) {
        return 'EXPECTED: Login required - $e';
      }
      return 'FAIL: $e';
    }
  }

  /// Test booking flow with mock data
  static Future<String> testBookingFlow(WidgetRef ref, {
    required int showId,
    required List<int> seatIds,
  }) async {
    try {
      // Check authentication first
      final isAuth = await AuthHelper.isAuthenticated();
      if (!isAuth) {
        return 'FAIL: User not authenticated for booking';
      }

      // Try to make a booking
      final bookingService = ref.read(bookingServiceProvider);
      final bookingId = await bookingService.book(
        showId: showId,
        seatIds: seatIds,
      );
      
      return 'PASS: Booking created with ID $bookingId';
    } catch (e) {
      if (e.toString().contains('login')) {
        return 'EXPECTED: Login required for booking - $e';
      }
      return 'FAIL: Booking failed - $e';
    }
  }

  /// Test auth state consistency
  static Future<String> testAuthStateConsistency(WidgetRef ref) async {
    try {
      final helperAuth = await AuthHelper.isAuthenticated();
      final providerAuth = ref.read(authStateProvider);
      
      final providerHasUser = providerAuth.when(
        loading: () => false,
        error: (_, __) => false,
        data: (user) => user != null,
      );

      if (helperAuth == providerHasUser) {
        return 'PASS: Auth state consistent between helper and provider';
      } else {
        return 'FAIL: Auth state mismatch - Helper: $helperAuth, Provider: $providerHasUser';
      }
    } catch (e) {
      return 'FAIL: Auth state test error - $e';
    }
  }
}

/// Widget to display test results in development
class BookingTestWidget extends ConsumerWidget {
  const BookingTestWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Tests')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Booking System Tests', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final result = await BookingTestHelper.testAuthStateConsistency(ref);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result)),
                  );
                }
              },
              child: const Text('Test Auth State Consistency'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final result = await BookingTestHelper.testBookingHistoryAccess(ref);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result)),
                  );
                }
              },
              child: const Text('Test Booking History Access'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final result = await BookingTestHelper.testBookingFlow(
                  ref,
                  showId: 1001, // Mock show ID
                  seatIds: [1, 2], // Mock seat IDs
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result)),
                  );
                }
              },
              child: const Text('Test Booking Flow'),
            ),
          ],
        ),
      ),
    );
  }
}