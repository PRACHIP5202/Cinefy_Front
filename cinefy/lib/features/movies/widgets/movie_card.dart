import 'package:flutter/material.dart';
import 'movie_poster.dart';
import 'rating_chip.dart';


class MovieCard extends StatelessWidget {
final String title;
final String posterUrl;
final double? rating;
final VoidCallback onTap;
const MovieCard({super.key, required this.title, required this.posterUrl, this.rating, required this.onTap});


@override
Widget build(BuildContext context) {
final cs = Theme.of(context).colorScheme;
return InkWell(
borderRadius: BorderRadius.circular(16),
onTap: onTap,
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Stack(
children: [
MoviePoster(url: posterUrl),
Positioned(
left: 8,
top: 8,
child: RatingChip(rating: rating),
),
],
),
const SizedBox(height: 8),
Text(
title,
maxLines: 2,
overflow: TextOverflow.ellipsis,
style: TextStyle(fontWeight: FontWeight.w700, color: cs.onSurface),
),
],
),
);
}
}