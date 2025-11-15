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
    Color borderColor;
    double borderOpacity;
    switch (visual) {
      case SeatVisual.booked:
        bg = const Color(0xFFE57373); // Light red background - very visible
        fg = const Color(0xFFB71C1C); // Dark red text
        borderColor = const Color(0xFFD32F2F); // Red border
        borderOpacity = 1.0;
        break;
      case SeatVisual.selected:
        bg = cs.primary.withOpacity(.18);
        fg = cs.primary;
        borderColor = fg;
        borderOpacity = .6;
        break;
      case SeatVisual.available:
      default:
        bg = cs.surfaceContainerHighest.withOpacity(.7);
        fg = cs.onSurface;
        borderColor = fg;
        borderOpacity = .6;
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
          border: Border.all(color: borderColor.withOpacity(borderOpacity), width: 1),
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
