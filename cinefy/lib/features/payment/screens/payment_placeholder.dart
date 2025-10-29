import 'package:flutter/material.dart';


class PaymentPlaceholder extends StatelessWidget {
final int bookingId;
const PaymentPlaceholder({super.key, required this.bookingId});


@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text('Payment')),
body: Center(
child: Padding(
padding: const EdgeInsets.all(24),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
const Icon(Icons.payment_rounded, size: 72),
const SizedBox(height: 12),
Text('Proceed to payment for booking #$bookingId', style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
const SizedBox(height: 8),
const Text('Stage 5 will implement initiate/confirm payment.'),
],
),
),
),
);
}
}