import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/seat_model.dart';
import '../services/seat_service.dart';
import '../../booking/services/booking_service.dart';


final seatServiceProvider = Provider<SeatService>((_) => SeatService());
final bookingServiceProvider = Provider<BookingService>((_) => BookingService());


final seatsProvider = FutureProvider.family<List<SeatModel>, int>((ref, showId) async {
final svc = ref.read(seatServiceProvider);
return svc.fetchSeats(showId);
});


class SelectionState {
final Set<int> selected; // seat ids
final int pricePerSeat; // fixed ₹
final int maxSeats;


const SelectionState({this.selected = const {}, this.pricePerSeat = 250, this.maxSeats = 50});


int get total => selected.length * pricePerSeat;


SelectionState copyWith({Set<int>? selected, int? pricePerSeat, int? maxSeats}) =>
SelectionState(selected: selected ?? this.selected, pricePerSeat: pricePerSeat ?? this.pricePerSeat, maxSeats: maxSeats ?? this.maxSeats);
}


final selectionProvider = StateNotifierProvider<SelectionController, SelectionState>((ref) => SelectionController());


class SelectionController extends StateNotifier<SelectionState> {
SelectionController() : super(const SelectionState());


void toggle(int seatId) {
final s = Set<int>.from(state.selected);
if (s.contains(seatId)) {
s.remove(seatId);
} else {
if (s.length >= state.maxSeats) return; // ignore if max reached
s.add(seatId);
}
state = state.copyWith(selected: s);
}


void clear() => state = state.copyWith(selected: <int>{});
}