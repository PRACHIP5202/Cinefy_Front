import 'package:flutter/material.dart';
import 'movie_poster.dart';
import 'rating_chip.dart';

class MovieCard extends StatelessWidget {
  final String title;
  final String posterUrl;
  final double? rating;
  final VoidCallback onTap;

  const MovieCard({
    super.key,
    required this.title,
    required this.posterUrl,
    this.rating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;

    // 🎚 Responsive scaling based on width
    double titleFontSize = 16;
    double spacing = 12;
    double borderRadius = 18;
    double elevation = 1.5;
    if (width > 600) {
      titleFontSize = 18;
      spacing = 15;
      borderRadius = 22;
      elevation = 2.5;
    }
    if (width > 900) {
      titleFontSize = 20;
      spacing = 18;
      borderRadius = 24;
      elevation = 3.5;
    }
    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(borderRadius),
      color: cs.surfaceVariant.withOpacity(0.93),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(spacing),
          child: Column(
            children: [
              // 🎬 Movie Poster with rating overlay
              AspectRatio(
                aspectRatio: 2 / 3,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: MoviePoster(url: posterUrl, borderRadius: borderRadius),
                    ),
                    Positioned(
                      left: 10,
                      top: 10,
                      child: RatingChip(rating: rating),
                    )
                  ],
                ),
              ),
              SizedBox(height: spacing),
              // 🧾 Movie Title (responsive text)
              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: cs.onSurface,
                      fontSize: titleFontSize,
                      height: 1.22,
                    ),
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
