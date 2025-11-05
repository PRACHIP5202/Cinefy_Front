class BookingHistoryItem {
  final int id;
  final int showId;
  final List<int> seatIds;
  final double totalPrice;
  final String paymentStatus;
  final String movieTitle;
  final String theatreName;
  final DateTime showTime;
  final DateTime createdAt;

  BookingHistoryItem({
    required this.id,
    required this.showId,
    required this.seatIds,
    required this.totalPrice,
    required this.paymentStatus,
    required this.movieTitle,
    required this.theatreName,
    required this.showTime,
    required this.createdAt,
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
      createdAt: DateTime.parse((j['createdAt'] as String?) ?? DateTime.now().toIso8601String()),
    );
  }
}

class BookingDetail {
  final int id;
  final int showId;
  final double totalPrice;
  final String paymentStatus;
  final DateTime createdAt;
  final MovieInfo movie;
  final TheatreInfo theatre;
  final ShowInfo show;
  final List<SeatInfo> seats;
  final PaymentInfo? payment;
  final TicketInfo? ticket;

  BookingDetail({
    required this.id,
    required this.showId,
    required this.totalPrice,
    required this.paymentStatus,
    required this.createdAt,
    required this.movie,
    required this.theatre,
    required this.show,
    required this.seats,
    this.payment,
    this.ticket,
  });

  factory BookingDetail.fromJson(Map<String, dynamic> j) {
    final movieData = j['movie'] as Map<String, dynamic>;
    final theatreData = j['theatre'] as Map<String, dynamic>;
    final showData = j['show'] as Map<String, dynamic>;
    final seatsData = (j['seats'] as List).cast<Map<String, dynamic>>();
    final paymentData = j['payment'] as Map<String, dynamic>?;
    final ticketData = j['ticket'] as Map<String, dynamic>?;

    return BookingDetail(
      id: (j['id'] as num).toInt(),
      showId: (j['showId'] as num).toInt(),
      totalPrice: (j['totalPrice'] as num).toDouble(),
      paymentStatus: j['paymentStatus'] as String,
      createdAt: DateTime.parse(j['createdAt'] as String),
      movie: MovieInfo.fromJson(movieData),
      theatre: TheatreInfo.fromJson(theatreData),
      show: ShowInfo.fromJson(showData),
      seats: seatsData.map((s) => SeatInfo.fromJson(s)).toList(),
      payment: paymentData != null ? PaymentInfo.fromJson(paymentData) : null,
      ticket: ticketData != null ? TicketInfo.fromJson(ticketData) : null,
    );
  }
}

class MovieInfo {
  final int id;
  final String title;
  final String posterUrl;
  final String genre;
  final int duration;

  MovieInfo({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.genre,
    required this.duration,
  });

  factory MovieInfo.fromJson(Map<String, dynamic> j) {
    return MovieInfo(
      id: (j['id'] as num).toInt(),
      title: j['title'] as String,
      posterUrl: j['posterUrl'] as String,
      genre: j['genre'] as String,
      duration: (j['duration'] as num).toInt(),
    );
  }
}

class TheatreInfo {
  final int id;
  final String name;
  final String city;

  TheatreInfo({
    required this.id,
    required this.name,
    required this.city,
  });

  factory TheatreInfo.fromJson(Map<String, dynamic> j) {
    return TheatreInfo(
      id: (j['id'] as num).toInt(),
      name: j['name'] as String,
      city: j['city'] as String,
    );
  }
}

class ShowInfo {
  final int id;
  final DateTime showTime;

  ShowInfo({
    required this.id,
    required this.showTime,
  });

  factory ShowInfo.fromJson(Map<String, dynamic> j) {
    return ShowInfo(
      id: (j['id'] as num).toInt(),
      showTime: DateTime.parse(j['showTime'] as String),
    );
  }
}

class SeatInfo {
  final int id;
  final String seatNumber;

  SeatInfo({
    required this.id,
    required this.seatNumber,
  });

  factory SeatInfo.fromJson(Map<String, dynamic> j) {
    return SeatInfo(
      id: (j['id'] as num).toInt(),
      seatNumber: j['seatNumber'] as String,
    );
  }
}

class PaymentInfo {
  final int id;
  final double amount;
  final String status;
  final DateTime createdAt;

  PaymentInfo({
    required this.id,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> j) {
    return PaymentInfo(
      id: (j['id'] as num).toInt(),
      amount: (j['amount'] as num).toDouble(),
      status: j['status'] as String,
      createdAt: DateTime.parse(j['createdAt'] as String),
    );
  }
}

class TicketInfo {
  final int id;
  final String code;
  final String qrUrl;
  final DateTime createdAt;

  TicketInfo({
    required this.id,
    required this.code,
    required this.qrUrl,
    required this.createdAt,
  });

  factory TicketInfo.fromJson(Map<String, dynamic> j) {
    return TicketInfo(
      id: (j['id'] as num).toInt(),
      code: j['code'] as String,
      qrUrl: j['qrUrl'] as String,
      createdAt: DateTime.parse(j['createdAt'] as String),
    );
  }
}


