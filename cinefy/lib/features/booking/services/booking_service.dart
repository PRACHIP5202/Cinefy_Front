import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../models/booking_models.dart';
import '../../../core/services/auth_helper.dart';


class BookingService {
final Dio _dio = DioClient.instance;


Future<int> book({required int showId, required List<int> seatIds}) async {
// Ensure user is authenticated before making booking request
final isAuth = await AuthHelper.isAuthenticated();
if (!isAuth) {
throw Exception('Please login to book tickets');
}

try {
final res = await _dio.post('/booking/book', data: {
'showId': showId,
'seatIds': seatIds,
});
// assume response contains booking id
final data = res.data as Map<String, dynamic>;
return (data['id'] as num?)?.toInt() ?? (data['bookingId'] as num).toInt();
} on DioException catch (e) {
if (e.response?.statusCode == 401) {
throw Exception('Session expired. Please login again');
} else if (e.response?.statusCode == 409) {
throw Exception('Some seats were already booked. Please select different seats');
}
throw Exception('Booking failed: ${e.response?.data?['message'] ?? e.message}');
} catch (e) {
throw Exception('Booking failed: $e');
}
}

  Future<List<BookingHistoryItem>> history() async {
    // Check authentication before making API call
    final isAuth = await AuthHelper.isAuthenticated();
    if (!isAuth) {
      throw DioException(
        requestOptions: RequestOptions(path: '/booking/history'),
        response: Response(
          requestOptions: RequestOptions(path: '/booking/history'),
          statusCode: 401,
          data: {'message': 'Unauthorized'},
        ),
      );
    }

    try {
      final res = await _dio.get('/booking/history');
      final list = (res.data as List).cast<Map<String, dynamic>>();
      return list.map(BookingHistoryItem.fromJson).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // Re-throw 401 errors so the UI can handle them properly
        rethrow;
      }
      throw Exception('Failed to load booking history: ${e.response?.data?['message'] ?? e.message}');
    }
  }

  Future<BookingDetail> getBookingById(int bookingId) async {
    // Check authentication before making API call
    final isAuth = await AuthHelper.isAuthenticated();
    if (!isAuth) {
      throw Exception('Please login to view booking details');
    }

    try {
      final res = await _dio.get('/booking/$bookingId');
      return BookingDetail.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Session expired. Please login again');
      } else if (e.response?.statusCode == 403) {
        throw Exception('Access denied. You can only view your own bookings');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Booking not found');
      }
      throw Exception('Failed to load booking details: ${e.response?.data?['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Failed to load booking details: $e');
    }
  }
}