class TheatreModel {
final int id;
final String name;
final String city;
final double latitude;
final double longitude;
final List<int> movieIds; // best-effort mapping


TheatreModel({
required this.id,
required this.name,
required this.city,
required this.latitude,
required this.longitude,
required this.movieIds,
});


factory TheatreModel.fromJson(Map<String, dynamic> j) {
List<int> parseMovieIds(dynamic raw) {
if (raw == null) return <int>[];
if (raw is List) {
if (raw.isEmpty) return <int>[];
if (raw.first is int) return raw.cast<int>();
// sometimes backend may embed movies as objects
if (raw.first is Map) {
return raw
.map((e) => (e as Map)['id'])
.where((id) => id is int)
.cast<int>()
.toList();
}
}
return <int>[];
}


return TheatreModel(
id: (j['id'] as num).toInt(),
name: j['name'] as String,
city: j['city'] as String,
latitude: (j['latitude'] as num).toDouble(),
longitude: (j['longitude'] as num).toDouble(),
movieIds: parseMovieIds(j['movieIds'] ?? j['movies']),
);
}
}