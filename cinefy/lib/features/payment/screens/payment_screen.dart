import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/payment_providers.dart';
import '../widgets/payment_summary_card.dart';


class PaymentScreen extends ConsumerWidget {
final int bookingId;
const PaymentScreen({super.key, required this.bookingId});


@override
Widget build(BuildContext context, WidgetRef ref) {
final flow = ref.watch(paymentFlowProvider(bookingId));


return Scaffold(
appBar: AppBar(title: const Text('Payment Confirmation')),
body: flow.when(
loading: () => const _CenterLoader(text: 'Confirming your booking...'),
error: (e, _) => _CenterError(error: e.toString(), onBack: () => context.pop()),
data: (result) {
// Basic fallback: seats count estimated from QR code absence is 0. In real app, fetch booking details.
final seatsCount = _tryGetSeatCountFromTicketCode(result.ticket.code);
return SingleChildScrollView(
padding: const EdgeInsets.symmetric(vertical: 16),
child: Column(
children: [
PaymentSummaryCard(
bookingId: bookingId,
seatsCount: seatsCount,
totalAmount: result.amount,
),
const SizedBox(height: 16),
_QrTicketPreview(qrUrl: result.ticket.qrUrl, code: result.ticket.code),
const SizedBox(height: 16),
],
),
);
},
),
);
}
int _tryGetSeatCountFromTicketCode(String code) {
// Fallback: if code encodes count like XYZ-5, parse; else 0
final parts = code.split('-');
if (parts.isNotEmpty) {
final n = int.tryParse(parts.last);
if (n != null) return n;
}
return 0;
}
}
class _QrTicketPreview extends StatelessWidget {
final String qrUrl;
final String code;
const _QrTicketPreview({required this.qrUrl, required this.code});


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
),
child: Column(
children: [
ClipRRect(
borderRadius: BorderRadius.circular(12),
child: AspectRatio(
aspectRatio: 1,
child: Image.network(qrUrl, fit: BoxFit.cover),
),
),
const SizedBox(height: 12),
SelectableText('Code: $code', style: const TextStyle(fontWeight: FontWeight.w700)),
const SizedBox(height: 4),
Text('Show this QR at entry', style: TextStyle(color: cs.onSurfaceVariant)),
],
),
);
}
}


class _CenterLoader extends StatelessWidget {
final String text;
const _CenterLoader({required this.text});
@override
Widget build(BuildContext context) {
return Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
const CircularProgressIndicator(),
const SizedBox(height: 12),
Text(text),
],
),
);
}
}


class _CenterError extends StatelessWidget {
final String error;
final VoidCallback onBack;
const _CenterError({required this.error, required this.onBack});
@override
Widget build(BuildContext context) {
return Center(
child: Padding(
padding: const EdgeInsets.all(24),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
const Icon(Icons.error_outline_rounded, size: 64),
const SizedBox(height: 12),
Text(error, textAlign: TextAlign.center),
const SizedBox(height: 12),
OutlinedButton.icon(onPressed: onBack, icon: const Icon(Icons.arrow_back), label: const Text('Back')),
],
),
),
);
}
}