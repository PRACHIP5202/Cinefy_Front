import 'package:flutter/material.dart';


class PaymentSummaryCard extends StatelessWidget {
final int bookingId;
final int seatsCount;
final double totalAmount;
const PaymentSummaryCard({super.key, required this.bookingId, required this.seatsCount, required this.totalAmount});


@override
Widget build(BuildContext context) {
final cs = Theme.of(context).colorScheme;
return Container(
margin: const EdgeInsets.symmetric(horizontal: 16),
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: cs.surface,
borderRadius: BorderRadius.circular(20),
border: Border.all(color: cs.outlineVariant.withOpacity(.4)),
boxShadow: [BoxShadow(color: cs.primary.withOpacity(.06), blurRadius: 22, offset: const Offset(0, 10))],
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
Container(
width: 44,
height: 44,
decoration: BoxDecoration(
shape: BoxShape.circle,
gradient: LinearGradient(colors: [cs.primary, cs.secondary]),
),
child: const Icon(Icons.confirmation_number_rounded, color: Colors.white),
),
const SizedBox(width: 12),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text('Booking #$bookingId', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
const SizedBox(height: 2),
Text('Seats: $seatsCount', style: TextStyle(color: cs.onSurfaceVariant)),
],
),
),
],
),
const SizedBox(height: 12),
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text('Total', style: TextStyle(color: cs.onSurfaceVariant, fontWeight: FontWeight.w600)),
Text('₹ ${totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
],
),
],
),
);
}
}