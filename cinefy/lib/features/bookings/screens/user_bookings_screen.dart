import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../booking/screens/booking_history_screen.dart';


class UserBookingsScreen extends ConsumerWidget {
  const UserBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Reuse the existing BookingHistoryScreen to ensure consistent UI/design
    return const BookingHistoryScreen();
  }
}


