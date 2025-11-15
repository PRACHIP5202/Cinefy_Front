import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/seat_providers.dart';
import '../../booking/providers/booking_providers.dart' as booking_providers;
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
          // Build a lookup from seatNumber ("1".."100") to actual SeatModel
          final byNumber = {for (final s in seats) s.seatNumber: s};
          // ensure 1..100 grid even if API returned fewer
          final allNumbers = List.generate(100, (i) => i + 1);

          return Column(
            children: [
              const SizedBox(height: 12),
              const _ScreenBanner(),
              const SizedBox(height: 8),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final availableWidth = constraints.maxWidth - 24; // padding
                    final seatSize = ((availableWidth - 48 - 70) / 10).clamp(28.0, 42.0); // responsive size
                    final seatSpacing = seatSize * 0.15;
                    final aisleWidth = seatSize * 0.6;

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: 10, // 10 rows
                      itemBuilder: (ctx, rowIndex) {
                        // Add extra spacing after row 7 (8-2 configuration)
                        final isBackRow = rowIndex >= 8;
                        final bottomPadding = rowIndex == 7 ? 20.0 : 8.0;

                        return Padding(
                          padding: EdgeInsets.only(bottom: bottomPadding),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Left section: 2 seats
                              ...List.generate(2, (colIndex) {
                                final seatIndex = rowIndex * 10 + colIndex;
                                final number = allNumbers[seatIndex];
                                final seat = byNumber[number.toString()];
                                final realSeatId = seat?.id;
                                final isBooked = seat?.isBooked == true;
                                final isSelected = realSeatId != null && selection.selected.contains(realSeatId);
                                final visual = isBooked
                                    ? SeatVisual.booked
                                    : isSelected
                                        ? SeatVisual.selected
                                        : SeatVisual.available;
                                return Padding(
                                  padding: EdgeInsets.only(right: seatSpacing),
                                  child: SizedBox(
                                    width: seatSize,
                                    height: seatSize * 0.9,
                                    child: SeatTile(
                                      id: realSeatId ?? number,
                                      label: number.toString(),
                                      visual: visual,
                                      onTap: () {
                                        if (realSeatId == null) return;
                                        ref.read(selectionProvider.notifier).toggle(realSeatId);
                                      },
                                    ),
                                  ),
                                );
                              }),
                              // Left aisle
                              SizedBox(width: aisleWidth),
                              // Center section: 6 seats
                              ...List.generate(6, (colIndex) {
                                final seatIndex = rowIndex * 10 + colIndex + 2;
                                final number = allNumbers[seatIndex];
                                final seat = byNumber[number.toString()];
                                final realSeatId = seat?.id;
                                final isBooked = seat?.isBooked == true;
                                final isSelected = realSeatId != null && selection.selected.contains(realSeatId);
                                final visual = isBooked
                                    ? SeatVisual.booked
                                    : isSelected
                                        ? SeatVisual.selected
                                        : SeatVisual.available;
                                return Padding(
                                  padding: EdgeInsets.only(right: seatSpacing),
                                  child: SizedBox(
                                    width: seatSize,
                                    height: seatSize * 0.9,
                                    child: SeatTile(
                                      id: realSeatId ?? number,
                                      label: number.toString(),
                                      visual: visual,
                                      onTap: () {
                                        if (realSeatId == null) return;
                                        ref.read(selectionProvider.notifier).toggle(realSeatId);
                                      },
                                    ),
                                  ),
                                );
                              }),
                              // Right aisle
                              SizedBox(width: aisleWidth),
                              // Right section: 2 seats
                              ...List.generate(2, (colIndex) {
                                final seatIndex = rowIndex * 10 + colIndex + 8;
                                final number = allNumbers[seatIndex];
                                final seat = byNumber[number.toString()];
                                final realSeatId = seat?.id;
                                final isBooked = seat?.isBooked == true;
                                final isSelected = realSeatId != null && selection.selected.contains(realSeatId);
                                final visual = isBooked
                                    ? SeatVisual.booked
                                    : isSelected
                                        ? SeatVisual.selected
                                        : SeatVisual.available;
                                return Padding(
                                  padding: EdgeInsets.only(right: colIndex == 0 ? seatSpacing : 0),
                                  child: SizedBox(
                                    width: seatSize,
                                    height: seatSize * 0.9,
                                    child: SeatTile(
                                      id: realSeatId ?? number,
                                      label: number.toString(),
                                      visual: visual,
                                      onTap: () {
                                        if (realSeatId == null) return;
                                        ref.read(selectionProvider.notifier).toggle(realSeatId);
                                      },
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        );
                      },
                    );
                  },
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
                    // Show loading indicator
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (ctx) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );

                    try {
                      // Revalidate selected seats by refetching before booking
                      final seats = await ref.read(seatsProvider(showId).future);
                      final booked = seats.where((s) => s.isBooked).map((s) => s.id).toSet();
                      final conflict = selection.selected.any(booked.contains);
                      
                      if (conflict) {
                        if (context.mounted) {
                          Navigator.of(context).pop(); // Close loading dialog
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Some seats were just booked. Please pick again.')),
                          );
                        }
                        return;
                      }

                      final bookingId = await ref.read(booking_providers.bookingServiceProvider).book(
                            showId: showId,
                            seatIds: selection.selected.toList(),
                          );
                      
                      ref.read(selectionProvider.notifier).clear();
                      
                      if (context.mounted) {
                        Navigator.of(context).pop(); // Close loading dialog
                        context.push('/payment/$bookingId');
                      }
                    } catch (e) {
                      if (context.mounted) {
                        Navigator.of(context).pop(); // Close loading dialog
                        
                        // Handle specific error cases
                        String errorMessage = 'Booking failed';
                        if (e.toString().contains('login')) {
                          errorMessage = 'Please login to book tickets';
                          // Optionally navigate to login
                          context.push('/login');
                        } else if (e.toString().contains('Session expired')) {
                          errorMessage = 'Session expired. Please login again';
                          context.push('/login');
                        } else {
                          errorMessage = e.toString().replaceFirst('Exception: ', '');
                        }
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(errorMessage),
                            backgroundColor: Theme.of(context).colorScheme.error,
                          ),
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
