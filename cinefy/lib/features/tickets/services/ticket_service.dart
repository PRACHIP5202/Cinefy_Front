import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../../payment/models/payment_models.dart';


class TicketService {
final Dio _dio = DioClient.instance;


Future<TicketModel> getByBooking(int bookingId) async {
final res = await _dio.get('/ticket/booking/$bookingId');
return TicketModel.fromJson(res.data as Map<String, dynamic>);
}
}