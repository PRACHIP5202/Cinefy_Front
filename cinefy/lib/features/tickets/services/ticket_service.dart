import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../../payment/models/payment_models.dart';


class TicketService {
final Dio _dio = DioClient.instance;


Future<TicketModel> getByBooking(int bookingId) async {
    final res = await _dio.get('/ticket/booking/$bookingId');
    final map = res.data as Map<String, dynamic>;
    // Backend shape: { message: 'OK', data: { bookingId, code, qrUrl, ... } }
    final data = (map['data'] is Map<String, dynamic>) ? map['data'] as Map<String, dynamic> : map;
    return TicketModel.fromJson(data);
}
}