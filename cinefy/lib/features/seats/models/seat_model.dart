class SeatModel {
final int id; // 1..100
final String seatNumber; // same as id.toString()
final bool isBooked;


const SeatModel({required this.id, required this.seatNumber, required this.isBooked});


factory SeatModel.fromJson(Map<String, dynamic> j) => SeatModel(
id: (j['id'] as num).toInt(),
seatNumber: j['seatNumber'].toString(),
isBooked: (j['isBooked'] as bool?) ?? false,
);
}