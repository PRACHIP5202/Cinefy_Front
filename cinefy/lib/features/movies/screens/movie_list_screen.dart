import 'package:cinefy/features/auth/screens/auth_gate.dart';
import 'package:cinefy/features/profile/screens/profile_screen.dart';
import 'package:cinefy/features/bookings/screens/user_bookings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';
import 'package:cinefy/features/bookings/screens/user_bookings_screen.dart';

class MovieListScreen extends ConsumerWidget {
  const MovieListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movies = ref.watch(moviesStateProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Cinefy'),
        centerTitle: true,
      ),
      body: movies.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed to load movies\n$e')),
        data: (state) => state.visible.isEmpty
            ? Center(
                child: Text(
                  'No movies available',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              )
            : RefreshIndicator(
                onRefresh: () async => ref.read(moviesStateProvider.notifier).refresh(),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (n) {
                    if (n.metrics.pixels >= n.metrics.maxScrollExtent - 200) {
                      ref.read(moviesStateProvider.notifier).loadMore();
                    }
                    return false;
                  },
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;

                      int crossAxisCount = 2;
                      if (width > 600) crossAxisCount = 3;
                      if (width > 900) crossAxisCount = 4;
                      if (width > 1200) crossAxisCount = 5;

                      final aspectRatio = width > 800 ? 0.72 : 0.68;

                      return GridView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 22,
                          crossAxisSpacing: 18,
                          childAspectRatio: aspectRatio,
                        ),
                        itemCount: state.visible.length,
                        itemBuilder: (ctx, i) {
                          final m = state.visible[i];
                          return MovieCard(
                            title: m.title,
                            posterUrl: m.posterUrl,
                            rating: m.rating,
                            onTap: () => context.push('/movie/${m.id}'),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() { _selectedIndex = index; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          MovieListScreen(),
          UserBookingsScreen(),
          ProfileScreen(), // Use ProfileScreen, not AuthGate
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_filter_rounded),
            label: "Movies",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.airplane_ticket_rounded),
            label: "Bookings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          )
        ],
      ),
    );
  }
}
