class BookingHistoryItem {
  final int id;
  final int showId;
  final List<int> seatIds;
  final double totalPrice;
  final String paymentStatus;
  final String movieTitle;
  final String theatreName;
  final DateTime showTime;

  BookingHistoryItem({
    required this.id,
    required this.showId,
    required this.seatIds,
    required this.totalPrice,
    required this.paymentStatus,
    required this.movieTitle,
    required this.theatreName,
    required this.showTime,
  });

  factory BookingHistoryItem.fromJson(Map<String, dynamic> j) {
    final show = (j['show'] as Map<String, dynamic>?) ?? const {};
    final movie = (show['movie'] as Map<String, dynamic>?) ?? const {};
    final theatre = (show['theatre'] as Map<String, dynamic>?) ?? const {};
    final seatIdsRaw = j['seatIds'];
    final seatIds = seatIdsRaw is String
        ? seatIdsRaw
            .split(',')
            .map((e) => int.tryParse(e.trim()) ?? -1)
            .where((n) => n > 0)
            .toList()
        : (seatIdsRaw is List)
            ? seatIdsRaw.map((e) => (e as num).toInt()).toList()
            : <int>[];

    return BookingHistoryItem(
      id: (j['id'] as num).toInt(),
      showId: (j['showId'] as num).toInt(),
      seatIds: seatIds,
      totalPrice: (j['totalPrice'] as num).toDouble(),
      paymentStatus: (j['paymentStatus'] as String?) ?? 'PENDING',
      movieTitle: (movie['title'] as String?) ?? 'Unknown',
      theatreName: (theatre['name'] as String?) ?? 'Unknown',
      showTime: DateTime.parse((show['showTime'] as String?) ?? DateTime.now().toIso8601String()),
    );
  }
}


