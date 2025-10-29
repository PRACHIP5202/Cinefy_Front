import 'package:flutter/material.dart';

/// Visual state of a seat
enum SeatVisual { available, booked, selected }

class SeatTile extends StatelessWidget {
  final int id;
  final String label;
  final SeatVisual visual;
  final VoidCallback? onTap;

  const SeatTile({
    super.key,
    required this.id,
    required this.label,
    required this.visual,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Color bg;
    Color fg;
    switch (visual) {
      case SeatVisual.booked:
        bg = Colors.red.withOpacity(.18);
        fg = Colors.red.shade700;
        break;
      case SeatVisual.selected:
        bg = cs.primary.withOpacity(.18);
        fg = cs.primary;
        break;
      case SeatVisual.available:
      default:
        bg = cs.surfaceContainerHighest.withOpacity(.7);
        fg = cs.onSurface;
        break;
    }

    return InkWell(
      onTap: visual == SeatVisual.booked ? null : onTap,
      borderRadius: BorderRadius.circular(8),
      child: Ink(
        width: 42,
        height: 38,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: fg.withOpacity(.6), width: 1),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: fg,
            ),
          ),
        ),
      ),
    );
  }
}
