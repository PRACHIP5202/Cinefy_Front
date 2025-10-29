import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/seat_providers.dart';
// Import SeatTile AND the SeatVisual enum from the same file
import '../widgets/seat_tile.dart' show SeatTile, SeatVisual;

class SeatSelectionScreen extends ConsumerWidget {
  final int showId;
  const SeatSelectionScreen({super.key, required this.showId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seatsAsync = ref.watch(seatsProvider(showId));
    final selection = ref.watch(selectionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Select Seats')),
      body: seatsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed to load seats\n$e')),
        data: (seats) {
          // ensure 1..100 grid even if API returned fewer
          final allIds = List.generate(100, (i) => i + 1);
          final bookedSet = seats.where((s) => s.isBooked).map((s) => s.id).toSet();

          return Column(
            children: [
              const SizedBox(height: 12),
              const _ScreenBanner(),
              const SizedBox(height: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 10, // 10 per row
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 42 / 38,
                    ),
                    itemCount: allIds.length,
                    itemBuilder: (ctx, i) {
                      final id = allIds[i];
                      final isBooked = bookedSet.contains(id);
                      final isSelected = selection.selected.contains(id);
                      final visual = isBooked
                          ? SeatVisual.booked
                          : isSelected
                              ? SeatVisual.selected
                              : SeatVisual.available;
                      return SeatTile(
                        id: id,
                        label: id.toString(),
                        visual: visual,
                        onTap: () => ref.read(selectionProvider.notifier).toggle(id),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const _LegendRow(),
              const SizedBox(height: 6),
              _BottomBar(showId: showId),
            ],
          );
        },
      ),
    );
  }
}

class _ScreenBanner extends StatelessWidget {
  const _ScreenBanner();
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 26,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [cs.secondary, cs.primary]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Text(
            'SCREEN',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow();
  Widget _dot(Color c) =>
      Container(width: 12, height: 12, decoration: BoxDecoration(color: c, shape: BoxShape.circle));
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(children: [_dot(cs.surfaceContainerHighest.withOpacity(.9)), const SizedBox(width: 6), const Text('Available')]),
          Row(children: [_dot(Colors.red.shade700), const SizedBox(width: 6), const Text('Booked')]),
          Row(children: [_dot(cs.primary), const SizedBox(width: 6), const Text('Selected')]),
        ],
      ),
    );
  }
}

class _BottomBar extends ConsumerWidget {
  final int showId;
  const _BottomBar({required this.showId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = ref.watch(selectionProvider);
    final canBook = selection.selected.isNotEmpty;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 12, offset: const Offset(0, -4))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Selected: ${selection.selected.length} seats'),
                const SizedBox(height: 2),
                const SizedBox(height: 2),
                Text(
                  'Total: ₹ ${selection.total}',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
              ],
            ),
          ),
          FilledButton.icon(
            onPressed: canBook
                ? () async {
                    // Revalidate selected seats by refetching before booking
                    final seats = await ref.read(seatsProvider(showId).future);
                    final booked = seats.where((s) => s.isBooked).map((s) => s.id).toSet();
                    final conflict = selection.selected.any(booked.contains);
                    if (conflict) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Some seats were just booked. Please pick again.')),
                        );
                      }
                      return;
                    }
                    try {
                      final bookingId = await ref.read(bookingServiceProvider).book(
                            showId: showId,
                            seatIds: selection.selected.toList(),
                          );
                      ref.read(selectionProvider.notifier).clear();
                      if (context.mounted) context.push('/payment/$bookingId');
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Booking failed: $e')),
                        );
                      }
                    }
                  }
                : null,
            icon: const Icon(Icons.lock_open_rounded),
            label: const Text('Book Now'),
          ),
        ],
      ),
    );
  }
}
