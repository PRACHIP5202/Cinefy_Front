import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../models/seat_model.dart';


class SeatService {
final Dio _dio = DioClient.instance;


Future<List<SeatModel>> fetchSeats(int showId) async {
try {
final res = await _dio.get('/booking/seats/$showId');
final list = (res.data as List).cast<Map<String, dynamic>>();
return list.map(SeatModel.fromJson).toList();
} catch (_) {
// Fallback mock: 100 seats, none booked
return List.generate(100, (i) => i + 1).map((n) => SeatModel(id: n, seatNumber: n.toString(), isBooked: false)).toList();
}
}
}