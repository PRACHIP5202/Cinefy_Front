import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/payment_models.dart';
import '../services/payment_service.dart';
import '../../tickets/services/ticket_service.dart';


final paymentServiceProvider = Provider<PaymentService>((_) => PaymentService());
final ticketServiceProvider = Provider<TicketService>((_) => TicketService());


/// Orchestrates: initiate → auto-confirm → fetch ticket
final paymentFlowProvider = FutureProvider.family<PaymentFlowResult, int>((ref, bookingId) async {
final paymentSvc = ref.read(paymentServiceProvider);
final ticketSvc = ref.read(ticketServiceProvider);


// Initiate
final init = await paymentSvc.initiate(bookingId);
// Auto-confirm success
await paymentSvc.confirm(init.paymentId, success: true);
// Fetch ticket
final ticket = await ticketSvc.getByBooking(bookingId);


// Compose minimal booking summary from ticket + amount (fallbacks if missing)
return PaymentFlowResult(
bookingId: bookingId,
paymentId: init.paymentId,
amount: init.amount,
ticket: ticket,
);
});


class PaymentFlowResult {
final int bookingId;
final int paymentId;
final double amount;
final TicketModel ticket;
const PaymentFlowResult({required this.bookingId, required this.paymentId, required this.amount, required this.ticket});
}