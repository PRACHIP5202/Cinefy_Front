import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../models/movie_model.dart';


class MovieService {
final Dio _dio = DioClient.instance;


Future<List<MovieModel>> fetchMovies() async {
final res = await _dio.get('/movies');
final list = (res.data as List).cast<Map<String, dynamic>>();
return list.map(MovieModel.fromJson).toList();
}


Future<MovieModel> fetchMovieDetail(int id) async {
final res = await _dio.get('/movies/$id');
return MovieModel.fromJson(res.data as Map<String, dynamic>);
}
}