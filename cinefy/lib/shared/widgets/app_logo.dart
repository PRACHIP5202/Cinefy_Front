import 'package:flutter/material.dart';


class AppLogo extends StatelessWidget {
const AppLogo({super.key});


@override
Widget build(BuildContext context) {
final cs = Theme.of(context).colorScheme;
return Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Container(
padding: const EdgeInsets.all(10),
decoration: BoxDecoration(
shape: BoxShape.circle,
gradient: LinearGradient(colors: [cs.primary, cs.secondary]),
boxShadow: [BoxShadow(color: cs.primary.withOpacity(.35), blurRadius: 16, spreadRadius: 2)],
),
child: const Icon(Icons.local_movies_rounded, size: 36, color: Colors.white),
),
const SizedBox(width: 10),
Text('Cinefy', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 26, color: cs.primary)),
],
);
}
}