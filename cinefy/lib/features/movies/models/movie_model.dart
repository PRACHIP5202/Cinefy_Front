class MovieModel {
final int id;
final String title;
final String description;
final String genre;
final int duration; // minutes
final DateTime releaseDate;
final String posterUrl;
final double? rating;


MovieModel({
required this.id,
required this.title,
required this.description,
required this.genre,
required this.duration,
required this.releaseDate,
required this.posterUrl,
required this.rating,
});


factory MovieModel.fromJson(Map<String, dynamic> j) => MovieModel(
id: j['id'] as int,
title: j['title'] as String,
description: j['description'] as String,
genre: j['genre'] as String,
duration: (j['duration'] as num).toInt(),
releaseDate: DateTime.parse(j['releaseDate'] as String),
posterUrl: j['posterUrl'] as String,
rating: j['rating'] == null ? null : (j['rating'] as num).toDouble(),
);
}