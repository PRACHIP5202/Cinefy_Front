import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import '../providers/booking_providers.dart';


class BookingHistoryScreen extends ConsumerWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(bookingHistoryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: history.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) {
          final unauthorized = e is DioException && e.response?.statusCode == 401;
          final loginRequired = e.toString().contains('Please login');
          
          if (unauthorized || loginRequired) {
            return _AuthRequired(onLogin: () => context.push('/login'));
          }
          return Center(child: Text('Failed to load bookings\n${e.toString().replaceFirst('Exception: ', '')}'));
        },
        data: (items) {
          if (items.isEmpty) {
            return const _EmptyView();
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (ctx, i) {
              final b = items[i];
              return _BookingTile(
                title: b.movieTitle,
                subtitle: b.theatreName,
                showTime: b.showTime,
                seatCount: b.seatIds.length,
                amount: b.totalPrice,
                status: b.paymentStatus,
                createdAt: b.createdAt,
                onTap: () => context.push('/booking-detail/${b.id}'),
              );
            },
          );
        },
      ),
    );
  }
}

class _BookingTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final DateTime showTime;
  final int seatCount;
  final double amount;
  final String status;
  final DateTime createdAt;
  final VoidCallback? onTap;
  const _BookingTile({
    required this.title,
    required this.subtitle,
    required this.showTime,
    required this.seatCount,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final paid = status.toUpperCase() == 'SUCCESS';
    return ListTile(
      onTap: onTap,
      tileColor: cs.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: cs.outlineVariant.withOpacity(.4))),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle),
          const SizedBox(height: 2),
          Text('${_fmt(showTime)} • $seatCount seats'),
          const SizedBox(height: 2),
          Text('Booked: ${_fmtDate(createdAt)}', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('₹ ${amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: paid ? Colors.green.withOpacity(.15) : Colors.orange.withOpacity(.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(paid ? 'PAID' : status.toUpperCase(), style: TextStyle(color: paid ? Colors.green.shade800 : Colors.orange.shade800, fontSize: 12, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime dt) {
    final d = '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    final t = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    return '$d $t';
  }

  String _fmtDate(DateTime dt) {
    final d = '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    return d;
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.event_busy_rounded, size: 54),
            SizedBox(height: 8),
            Text('No bookings yet'),
          ],
        ),
      ),
    );
  }
}


class _AuthRequired extends StatelessWidget {
  final VoidCallback onLogin;
  const _AuthRequired({required this.onLogin});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline_rounded, size: 54),
            const SizedBox(height: 12),
            const Text('Please sign in to view your bookings'),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onLogin,
              icon: const Icon(Icons.login_rounded),
              label: const Text('Sign in'),
            ),
          ],
        ),
      ),
    );
  }
}

