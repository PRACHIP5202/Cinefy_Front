import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/booking_models.dart';
import '../services/booking_service.dart';


final bookingServiceProvider = Provider<BookingService>((_) => BookingService());


final bookingHistoryProvider = FutureProvider<List<BookingHistoryItem>>((ref) async {
  final svc = ref.read(bookingServiceProvider);
  return svc.history();
});


