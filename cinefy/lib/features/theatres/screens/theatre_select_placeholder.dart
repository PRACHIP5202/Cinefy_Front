import 'package:flutter/material.dart';


class TheatreSelectPlaceholder extends StatelessWidget {
final int movieId;
const TheatreSelectPlaceholder({super.key, required this.movieId});


@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text('Select Theatre & Showtime')),
body: Center(
child: Padding(
padding: const EdgeInsets.all(24),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
const Icon(Icons.event_seat_rounded, size: 64),
const SizedBox(height: 12),
Text(
'Theatre selection for Movie #$movieId',
style: Theme.of(context).textTheme.titleLarge,
textAlign: TextAlign.center,
),
const SizedBox(height: 8),
const Text('Stage 3 will implement theatres, nearest city, and showtimes.'),
],
),
),
),
);
}
}