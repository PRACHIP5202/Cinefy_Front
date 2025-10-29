import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../movies/models/movie_model.dart';
import '../models/theatre_model.dart';
import '../services/theatre_service.dart';


final theatreServiceProvider = Provider<TheatreService>((_) => TheatreService());


final theatresProvider = FutureProvider<List<TheatreModel>>((ref) async {
final svc = ref.read(theatreServiceProvider);
return svc.fetchTheatres();
});


/// Cities derived from theatres (unique)
final theatreCitiesProvider = Provider<List<String>>((ref) {
final async = ref.watch(theatresProvider);
return async.maybeWhen(
data: (list) {
final set = {...list.map((t) => t.city)};
final cities = set.toList()..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
return cities;
},
orElse: () => const <String>[]
);
});


/// Selected city state (defaults to first city when data arrives)
final selectedCityProvider = StateProvider<String?>((ref) => null);


/// Theatres filtered by movie & city
final filteredTheatresProvider = Provider.family<List<TheatreModel>, int>((ref, movieId) {
final theatresAsync = ref.watch(theatresProvider);
final selectedCity = ref.watch(selectedCityProvider);


return theatresAsync.maybeWhen(
data: (list) {
// filter by movieId if theatre.movieIds includes it; if list empty, show all
final byMovie = list.where((t) => t.movieIds.isEmpty || t.movieIds.contains(movieId)).toList();
if (selectedCity == null || selectedCity.isEmpty) return byMovie;
return byMovie.where((t) => t.city.toLowerCase() == selectedCity.toLowerCase()).toList();
},
orElse: () => const <TheatreModel>[]
);
});