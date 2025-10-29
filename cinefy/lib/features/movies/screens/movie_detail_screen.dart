// =============================
// lib/features/movies/screens/movie_detail_screen.dart
// =============================
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_poster.dart';
import '../widgets/rating_chip.dart';
class MovieDetailScreen extends ConsumerWidget {
final int id;
const MovieDetailScreen({super.key, required this.id});


@override
Widget build(BuildContext context, WidgetRef ref) {
final movieAsync = ref.watch(movieDetailProvider(id));
final cs = Theme.of(context).colorScheme;


return Scaffold(
backgroundColor: cs.surface,
appBar: AppBar(title: const Text('Movie Details')),
body: movieAsync.when(
loading: () => const Center(child: CircularProgressIndicator()),
error: (e, _) => Center(child: Text('Error: $e')),
data: (m) => SingleChildScrollView(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
// Hero-ish top poster
MoviePoster(url: m.posterUrl, borderRadius: 20),
const SizedBox(height: 16),
Row(
crossAxisAlignment: CrossAxisAlignment.center,
children: [
Expanded(
child: Text(
m.title,
style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
),
),
RatingChip(rating: m.rating),
],
),
const SizedBox(height: 8),
Wrap(
spacing: 10,
runSpacing: 10,
children: [
_InfoChip(icon: Icons.category_rounded, label: m.genre),
_InfoChip(icon: Icons.timer_rounded, label: '${m.duration} min'),
_InfoChip(icon: Icons.event_rounded, label: _formatDate(m.releaseDate)),
],
),
const SizedBox(height: 16),
Text(
m.description,
style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.4),
),
const SizedBox(height: 24),
SizedBox(
width: double.infinity,
child: FilledButton.icon(
icon: const Icon(Icons.event_seat_rounded),
label: const Text('Book Now'),
onPressed: () => context.push('/theatre-select/${m.id}'),
),
),
],
),
),
),
);
}
String _formatDate(DateTime d) {
return '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';
}
}


class _InfoChip extends StatelessWidget {
final IconData icon;
final String label;
const _InfoChip({required this.icon, required this.label});


@override
Widget build(BuildContext context) {
final cs = Theme.of(context).colorScheme;
return Container(
padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
decoration: BoxDecoration(
color: cs.secondaryContainer.withOpacity(.4),
borderRadius: BorderRadius.circular(20),
),
child: Row(
mainAxisSize: MainAxisSize.min,
children: [
Icon(icon, size: 16, color: cs.onSecondaryContainer),
const SizedBox(width: 6),
Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: cs.onSecondaryContainer)),
],
),
);
}
}