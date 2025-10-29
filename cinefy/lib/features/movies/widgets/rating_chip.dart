import 'package:flutter/material.dart';


class RatingChip extends StatelessWidget {
final double? rating; // null-safe
const RatingChip({super.key, this.rating});


@override
Widget build(BuildContext context) {
final cs = Theme.of(context).colorScheme;
final text = rating == null ? 'NR' : rating!.toStringAsFixed(1);
return Container(
padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
decoration: BoxDecoration(
color: cs.primary.withOpacity(.12),
borderRadius: BorderRadius.circular(10),
border: Border.all(color: cs.primary.withOpacity(.3)),
),
child: Row(
mainAxisSize: MainAxisSize.min,
children: [
Icon(Icons.star_rounded, size: 16, color: cs.primary),
const SizedBox(width: 4),
Text(text, style: TextStyle(fontWeight: FontWeight.w600, color: cs.primary)),
],
),
);
}
}