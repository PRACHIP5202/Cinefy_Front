import 'package:flutter/material.dart';
import '../models/theatre_model.dart';


class TheatreCard extends StatelessWidget {
final TheatreModel theatre;
final VoidCallback? onTap;
const TheatreCard({super.key, required this.theatre, this.onTap});

@override
Widget build(BuildContext context) {
final cs = Theme.of(context).colorScheme;
return InkWell(
borderRadius: BorderRadius.circular(18),
onTap: onTap,
child: Ink(
decoration: BoxDecoration(
color: cs.surface,
borderRadius: BorderRadius.circular(18),
boxShadow: [
BoxShadow(color: cs.primary.withOpacity(.08), blurRadius: 14, offset: const Offset(0, 6)),
],
border: Border.all(color: cs.outlineVariant.withOpacity(.4)),
),
child: Padding(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
Container(
height: 44,
width: 44,
decoration: BoxDecoration(
shape: BoxShape.circle,
gradient: LinearGradient(colors: [cs.primary, cs.secondary]),
),
child: const Icon(Icons.theaters_rounded, color: Colors.white),
),
const SizedBox(width: 12),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(theatre.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
const SizedBox(height: 2),
Row(
children: [
Icon(Icons.location_on_outlined, size: 16, color: cs.primary),
const SizedBox(width: 4),
Text(theatre.city, style: TextStyle(color: cs.onSurfaceVariant)),
],
),
],
),
),
],
),
const SizedBox(height: 10),
Row(
children: [
Icon(Icons.event_rounded, size: 18, color: cs.onSurfaceVariant),
const SizedBox(width: 6),
Expanded(
child: Text(
'Showtimes unavailable for now',
style: TextStyle(color: cs.onSurfaceVariant),
),
),
],
),
],
),
),
),
);
}
}