import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../models/theatre_model.dart';


class TheatreService {
final Dio _dio = DioClient.instance;


Future<List<TheatreModel>> fetchTheatres() async {
final res = await _dio.get('/theatres');
final list = (res.data as List).cast<Map<String, dynamic>>();
return list.map(TheatreModel.fromJson).toList();
}
}