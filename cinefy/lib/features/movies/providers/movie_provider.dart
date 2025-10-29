import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie_model.dart';
import '../services/movie_service.dart';


final movieServiceProvider = Provider<MovieService>((_) => MovieService());


/// Loads full list once, then exposes a paged view for infinite scroll.
final moviesStateProvider = StateNotifierProvider<MoviesController, AsyncValue<MoviesState>>((ref) {
return MoviesController(ref.read(movieServiceProvider));
});


class MoviesState {
final List<MovieModel> all; // full dataset
final int visibleCount; // how many currently shown
final bool loadingMore;


const MoviesState({required this.all, required this.visibleCount, required this.loadingMore});


MoviesState copyWith({List<MovieModel>? all, int? visibleCount, bool? loadingMore}) =>
MoviesState(all: all ?? this.all, visibleCount: visibleCount ?? this.visibleCount, loadingMore: loadingMore ?? this.loadingMore);


List<MovieModel> get visible => all.take(visibleCount).toList();
}


class MoviesController extends StateNotifier<AsyncValue<MoviesState>> {
final MovieService _service;
static const int _pageSize = 12; // items per page in grid


MoviesController(this._service) : super(const AsyncLoading()) {
load();
}


Future<void> load() async {
try {
final list = await _service.fetchMovies();
state = AsyncData(MoviesState(all: list, visibleCount: list.isEmpty ? 0 : _pageSize, loadingMore: false));
} catch (e, st) {
state = AsyncError(e, st);
}
}


Future<void> refresh() async => load();


void loadMore() {
final current = state.value;
if (current == null) return;
if (current.visibleCount >= current.all.length) return; // no more
final next = (current.visibleCount + _pageSize).clamp(0, current.all.length);
state = AsyncData(current.copyWith(visibleCount: next, loadingMore: next < current.all.length));
}
}


final movieDetailProvider = FutureProvider.family<MovieModel, int>((ref, id) async {
final svc = ref.read(movieServiceProvider);
return svc.fetchMovieDetail(id);
});