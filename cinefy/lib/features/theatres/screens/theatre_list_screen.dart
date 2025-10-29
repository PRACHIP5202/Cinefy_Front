import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/theatre_providers.dart';
import '../widgets/city_selector.dart';
import '../widgets/theatre_card.dart';


class TheatreListScreen extends ConsumerWidget {
final int movieId;
const TheatreListScreen({super.key, required this.movieId});


int _tempShowId(int theatreId, int movieId) => theatreId * 1000 + movieId; // client-only placeholder


@override
Widget build(BuildContext context, WidgetRef ref) {
final theatresAsync = ref.watch(theatresProvider);
final cities = ref.watch(theatreCitiesProvider);
final selectedCity = ref.watch(selectedCityProvider);


theatresAsync.whenOrNull(data: (_) {
final citiesNow = ref.read(theatreCitiesProvider);
final current = ref.read(selectedCityProvider);
if ((current == null || current.isEmpty) && citiesNow.isNotEmpty) {
ref.read(selectedCityProvider.notifier).state = citiesNow.first;
}
});


final filtered = ref.watch(filteredTheatresProvider(movieId));


return Scaffold(
appBar: AppBar(title: const Text('Select Theatre')),
body: theatresAsync.when(
loading: () => const Center(child: CircularProgressIndicator()),
error: (e, _) => Center(child: Text('Failed to load theatres\n$e')),
data: (_) => Padding(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
Row(
children: [
Expanded(
child: CitySelector(
cities: cities,
value: selectedCity,
onChanged: (v) => ref.read(selectedCityProvider.notifier).state = v,
),
),
],
),
const SizedBox(height: 16),
Expanded(
child: AnimatedSwitcher(
duration: const Duration(milliseconds: 250),
child: filtered.isEmpty
? const _EmptyView()
: ListView.separated(
key: ValueKey(selectedCity),
itemCount: filtered.length,
separatorBuilder: (_, __) => const SizedBox(height: 12),
itemBuilder: (ctx, i) {
final t = filtered[i];
return TheatreCard(
theatre: t,
onTap: () {
final showId = _tempShowId(t.id, movieId);
context.push('/seat-select/$showId');
},
);
},
),
),
),
],
),
),
),
);
}
}


class _EmptyView extends StatelessWidget {
const _EmptyView();
@override
Widget build(BuildContext context) {
return Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Icon(Icons.event_busy_rounded, size: 54, color: Theme.of(context).colorScheme.onSurfaceVariant),
const SizedBox(height: 8),
const Text('No theatres found in this city'),
],
),
);
}
}


