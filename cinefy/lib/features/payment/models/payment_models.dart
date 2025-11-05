class PaymentInitiateResponse {
final int paymentId;
final double amount;
PaymentInitiateResponse({required this.paymentId, required this.amount});
  factory PaymentInitiateResponse.fromJson(Map<String, dynamic> j) {
    // Backend returns { message, payment: { id, amount, ... }, ... }
    final p = (j['payment'] is Map<String, dynamic>) ? j['payment'] as Map<String, dynamic> : j;
    final pid = (p['id'] ?? p['paymentId']) as int;
    final amt = (p['amount'] as num).toDouble();
    return PaymentInitiateResponse(paymentId: pid, amount: amt);
  }
}


// Minimal Ticket + Booking models for preview
class TicketModel {
  final int id;
final int bookingId;
final String code;
final String qrUrl;
TicketModel({required this.id, required this.bookingId, required this.code, required this.qrUrl});
  factory TicketModel.fromJson(Map<String, dynamic> j) => TicketModel(
        // Some endpoints don't include an id for ticket preview; default to 0
        id: (j['id'] as num?)?.toInt() ?? 0,
        bookingId: (j['bookingId'] as num).toInt(),
        code: j['code'] as String,
        qrUrl: j['qrUrl'] as String,
      );
}


class BookingSummary {
final int id;
final int showId;
final List<int> seatIds;
final double totalPrice;
BookingSummary({required this.id, required this.showId, required this.seatIds, required this.totalPrice});
factory BookingSummary.fromJson(Map<String, dynamic> j) => BookingSummary(
id: (j['id'] ?? j['bookingId']) as int,
showId: (j['showId'] as num).toInt(),
seatIds: _parseSeatIds(j['seatIds']),
totalPrice: (j['totalPrice'] as num).toDouble(),
);
static List<int> _parseSeatIds(dynamic raw) {
if (raw is List) return raw.map((e) => (e as num).toInt()).toList();
if (raw is String) {
return raw
.split(',')
.map((e) => e.trim())
.where((e) => e.isNotEmpty)
.map((e) => int.tryParse(e) ?? -1)
.where((e) => e > 0)
.toList();
}
return const <int>[];
}
}