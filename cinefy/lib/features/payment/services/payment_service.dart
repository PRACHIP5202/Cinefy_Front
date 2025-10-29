import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../models/payment_models.dart';


class PaymentService {
final Dio _dio = DioClient.instance;


Future<PaymentInitiateResponse> initiate(int bookingId) async {
final res = await _dio.post('/payment/initiate', data: {
'bookingId': bookingId,
});
return PaymentInitiateResponse.fromJson(res.data as Map<String, dynamic>);
}


Future<void> confirm(int paymentId, {bool success = true}) async {
await _dio.post('/payment/confirm', data: {
'paymentId': paymentId,
'status': success ? 'SUCCESS' : 'FAILED',
});
}
}