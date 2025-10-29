import 'package:flutter/material.dart';


class CitySelector extends StatelessWidget {
final List<String> cities;
final String? value;
final ValueChanged<String?> onChanged;
const CitySelector({super.key, required this.cities, required this.value, required this.onChanged});


@override
Widget build(BuildContext context) {
final cs = Theme.of(context).colorScheme;
return Container(
padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
decoration: BoxDecoration(
color: cs.surface,
borderRadius: BorderRadius.circular(14),
border: Border.all(color: cs.outlineVariant.withOpacity(.5)),
),
child: DropdownButtonHideUnderline(
child: DropdownButton<String>(
value: value,
isExpanded: true,
hint: const Text('Select City'),
items: cities.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
onChanged: onChanged,
),
),
);
}
}