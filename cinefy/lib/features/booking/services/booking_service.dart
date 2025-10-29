import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';


class BookingService {
final Dio _dio = DioClient.instance;


Future<int> book({required int showId, required List<int> seatIds}) async {
final res = await _dio.post('/booking/book', data: {
'showId': showId,
'seatIds': seatIds,
});
// assume response contains booking id
final data = res.data as Map<String, dynamic>;
return (data['id'] as num?)?.toInt() ?? (data['bookingId'] as num).toInt();
}
}