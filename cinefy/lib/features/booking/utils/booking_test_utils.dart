import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/booking_providers.dart';
import '../../auth/providers/auth_providers.dart';
import '../../../core/services/auth_helper.dart';

/// Utility class for testing booking functionality in development
class BookingTestUtils {
  /// Test if the booking history loads correctly
  static Future<String> testBookingHistoryLoad(WidgetRef ref) async {
    try {
      // Check auth state first
      final authState = ref.read(authStateProvider);
      final isAuth = await AuthHelper.isAuthenticated();
      
      if (!isAuth) {
        return 'EXPECTED: User not authenticated - login required';
      }
      
      // Try to load booking history
      final history = await ref.read(bookingHistoryProvider.future);
      return 'SUCCESS: Loaded ${history.length} bookings';
    } catch (e) {
      if (e.toString().contains('login')) {
        return 'EXPECTED: Login required - ${e.toString()}';
      }
      return 'ERROR: ${e.toString()}';
    }
  }
  
  /// Test if a specific booking detail loads correctly
  static Future<String> testBookingDetailLoad(WidgetRef ref, int bookingId) async {
    try {
      // Check auth state first
      final isAuth = await AuthHelper.isAuthenticated();
      
      if (!isAuth) {
        return 'EXPECTED: User not authenticated - login required';
      }
      
      // Try to load booking detail
      final detail = await ref.read(bookingDetailProvider(bookingId).future);
      return 'SUCCESS: Loaded booking detail for "${detail.movie.title}" at ${detail.theatre.name}';
    } catch (e) {
      if (e.toString().contains('login')) {
        return 'EXPECTED: Login required - ${e.toString()}';
      } else if (e.toString().contains('not found')) {
        return 'EXPECTED: Booking not found - ${e.toString()}';
      }
      return 'ERROR: ${e.toString()}';
    }
  }
  
  /// Test the complete booking flow consistency
  static Future<String> testBookingFlowConsistency(WidgetRef ref) async {
    try {
      // Check if auth state is consistent
      final authState = ref.read(authStateProvider);
      final helperAuth = await AuthHelper.isAuthenticated();
      
      final providerHasUser = authState.when(
        loading: () => false,
        error: (_, __) => false,
        data: (user) => user != null,
      );
      
      if (helperAuth != providerHasUser) {
        return 'ERROR: Auth state inconsistent - Helper: $helperAuth, Provider: $providerHasUser';
      }
      
      if (!helperAuth) {
        return 'EXPECTED: User not authenticated - both helper and provider agree';
      }
      
      // Test if booking providers work with current auth state
      try {
        await ref.read(bookingHistoryProvider.future);
        return 'SUCCESS: Booking flow is consistent with auth state';
      } catch (e) {
        return 'ERROR: Booking flow failed despite auth - ${e.toString()}';
      }
    } catch (e) {
      return 'ERROR: Test failed - ${e.toString()}';
    }
  }
}

/// Widget for displaying booking test results in development
class BookingTestWidget extends ConsumerWidget {
  const BookingTestWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking System Tests'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking System Tests',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Use these tests to verify the booking system is working correctly.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await BookingTestUtils.testBookingFlowConsistency(ref);
                if (context.mounted) {
                  _showResult(context, 'Auth Consistency Test', result);
                }
              },
              icon: const Icon(Icons.verified_user),
              label: const Text('Test Auth Consistency'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await BookingTestUtils.testBookingHistoryLoad(ref);
                if (context.mounted) {
                  _showResult(context, 'Booking History Test', result);
                }
              },
              icon: const Icon(Icons.history),
              label: const Text('Test Booking History'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () async {
                // Test with a sample booking ID (1)
                final result = await BookingTestUtils.testBookingDetailLoad(ref, 1);
                if (context.mounted) {
                  _showResult(context, 'Booking Detail Test (ID: 1)', result);
                }
              },
              icon: const Icon(Icons.receipt_long),
              label: const Text('Test Booking Detail (ID: 1)'),
            ),
            const SizedBox(height: 24),
            Card(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Expected Results:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• If logged in: All tests should show SUCCESS\n'
                      '• If not logged in: Tests should show EXPECTED login required\n'
                      '• Auth consistency should always pass\n'
                      '• Booking detail test may show "not found" if no booking exists',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showResult(BuildContext context, String title, String result) {
    final isSuccess = result.startsWith('SUCCESS');
    final isExpected = result.startsWith('EXPECTED');
    
    Color backgroundColor;
    Color textColor;
    IconData icon;
    
    if (isSuccess) {
      backgroundColor = Colors.green.withValues(alpha: 0.1);
      textColor = Colors.green.shade800;
      icon = Icons.check_circle;
    } else if (isExpected) {
      backgroundColor = Colors.blue.withValues(alpha: 0.1);
      textColor = Colors.blue.shade800;
      icon = Icons.info;
    } else {
      backgroundColor = Colors.red.withValues(alpha: 0.1);
      textColor = Colors.red.shade800;
      icon = Icons.error;
    }
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(icon, color: textColor),
            const SizedBox(width: 8),
            Expanded(child: Text(title)),
          ],
        ),
        content: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            result,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}