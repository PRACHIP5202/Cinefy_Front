import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';


class MovieListScreen extends ConsumerWidget {
const MovieListScreen({super.key});


@override
Widget build(BuildContext context, WidgetRef ref) {
final movies = ref.watch(moviesStateProvider);


return Scaffold(
backgroundColor: Theme.of(context).colorScheme.surface,
appBar: AppBar(
title: const Text('Cinefy'),
centerTitle: true,
),
body: movies.when(
loading: () => const Center(child: CircularProgressIndicator()),
error: (e, _) => Center(child: Text('Failed to load movies\n$e')),
data: (state) => RefreshIndicator(
onRefresh: () async => ref.read(moviesStateProvider.notifier).refresh(),
child: NotificationListener<ScrollNotification>(
onNotification: (n) {
if (n.metrics.pixels >= n.metrics.maxScrollExtent - 200) {
ref.read(moviesStateProvider.notifier).loadMore();
}
return false;
},
child: GridView.builder(
padding: const EdgeInsets.all(16),
gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
crossAxisCount: 2,
mainAxisSpacing: 16,
crossAxisSpacing: 16,
childAspectRatio: 0.70, // space for title under 2:3 poster
),
itemCount: state.visible.length,
itemBuilder: (ctx, i) {
final m = state.visible[i];
return MovieCard(
title: m.title,
posterUrl: m.posterUrl,
rating: m.rating,
onTap: () => context.push('/movie/${m.id}'),
);
},
),
),
),
),
);
}
}