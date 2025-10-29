import 'package:flutter/material.dart';


class MoviePoster extends StatelessWidget {
final String url;
final double borderRadius;
const MoviePoster({super.key, required this.url, this.borderRadius = 16});


@override
Widget build(BuildContext context) {
return ClipRRect(
borderRadius: BorderRadius.circular(borderRadius),
child: AspectRatio(
aspectRatio: 2/3, // 2:3 poster ratio
child: Ink(
decoration: BoxDecoration(
image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
),
child: Container(
decoration: const BoxDecoration(
gradient: LinearGradient(
begin: Alignment.topCenter,
end: Alignment.bottomCenter,
colors: [Colors.transparent, Colors.black38, Colors.black87],
),
),
),
),
),
);
}
}