import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:watching/config/config.dart';
import 'package:watching/core/navigation/navigation.dart';
import 'package:watching/src/features/shows/presentation/discover/genres.dart';
import 'package:watching/src/features/shows/presentation/discover/languages.dart';
import 'package:watching/src/src.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    with SingleTickerProviderStateMixin {
  final List<Show> filteredList = [];
  String selectedGenre = '';
  String selectedLanguage = '';

  final searchController = TextEditingController();

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    context.read<ShowCubit>().getAllShows();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<ShowCubit>().getAllShows();
    return BlocBuilder<ShowCubit, ShowCubitState>(
      builder: (context, ShowCubitState state) {
        if (state.isLoading) {
          return const LoadingAnimation();
        } else if (state.isError) {
          return const Center(
            child: Text('Error fetching shows'),
          );
        } else {
          final shows = filteredList.isNotEmpty ? filteredList : state.shows;
          return Scaffold(
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: SearchWidget(
                    searchController: searchController,
                    resetSearch: () {
                      context.read<ShowCubit>().getAllShows();
                    },
                  ),
                ),
                SearchView(
                  shows: shows,
                  deleteFeature: false,
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.grey[800],
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          Tab(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Filter by genre'),
                                      TextButton(
                                        onPressed: clearFilters,
                                        child: const Text("Clear Filters"),
                                      ),
                                      // TextButton(
                                      //   onPressed: () =>
                                      //       _tabController.animateTo(1),
                                      //   child: const Text(
                                      //     "Languages",
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 160,
                                      childAspectRatio: 3 / 2,
                                      crossAxisSpacing: 0,
                                      mainAxisSpacing: 5,
                                    ),
                                    itemCount: genres.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            selectedGenre =
                                                genres[index].toString();
                                            final shows = state.shows;
                                            if (shows.isEmpty) return;
                                            filteredList
                                              ..clear()
                                              ..addAll(
                                                _matchShowGenre(shows).toList(),
                                              );
                                          });
                                        },
                                        child: Text(
                                          style: const TextStyle(fontSize: 12),
                                          genres[index].toString(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Tab(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Filter by language'),
                                      TextButton(
                                        onPressed: clearFilters,
                                        child: const Text("Clear Filters"),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            _tabController.animateTo(0),
                                        child: const Text(
                                          "Genres",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 160,
                                      childAspectRatio: 3 / 2,
                                      crossAxisSpacing: 0,
                                      mainAxisSpacing: 5,
                                    ),
                                    itemCount: languages.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            selectedLanguage =
                                                languages[index].toString();
                                            final shows = state.shows;
                                            if (shows.isEmpty) return;
                                            filteredList
                                              ..clear()
                                              ..addAll(
                                                _matchShowLanguage(shows)
                                                    .toList(),
                                              );
                                          });
                                        },
                                        child: Text(
                                          style: const TextStyle(fontSize: 12),
                                          languages[index].toString(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: const Icon(Icons.filter_list),
            ),
          );
        }
      },
    );
  }

  Iterable<Show> _matchShowGenre(List<Show> shows) {
    return shows.where(
      (show) => show.genres.contains(
        selectedGenre,
      ),
    );
  }

  Iterable<Show> _matchShowLanguage(List<Show> shows) {
    return shows.where(
      (show) => show.language.contains(
        selectedLanguage,
      ),
    );
  }

  // Method to clear filters
  void clearFilters() {
    setState(() {
      filteredList.clear();
      selectedGenre = '';
      selectedLanguage = '';
    });
  }
}

class SearchView extends StatelessWidget {
  const SearchView({
    required this.shows,
    required this.deleteFeature,
    super.key,
  });
  final List<Show> shows;
  final bool deleteFeature;
  @override
  Widget build(BuildContext context) {
    final FirebaseAuthRepository firebaseAuthRepository =
        FirebaseAuthRepository();
    final userId = firebaseAuthRepository.getUser()?.uid.hashCode;
    if (userId == null) {
      return const Center(
        child: Text('User not found'),
      );
    }
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          itemCount: shows.length,
          itemBuilder: (context, index) {
            if (index >= shows.length) return null;
            final Show show = shows[index];
            return InkWell(
              onTap: () {
                context.pushNamed(
                  WatchingRoutesNames.show,
                  pathParameters: {
                    'showId': show.id.toString(),
                  },
                );
              },
              child: SizedBox(
                height: 120,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: const Color(0xff1b1b29),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            top: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                show.name,
                                style: textTheme.displayLarge,
                              ),
                              Text(
                                show.language,
                                style: textTheme.displayMedium?.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                show.genres.join(', '),
                                style: textTheme.displayMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CachedNetworkImage(
                              imageUrl: show.image?.medium ??
                                  'https://i.imgur.com/U0xPF44.jpeg',
                              width: 90,
                              height: 120,
                              progressIndicatorBuilder:
                                  (context, url, progress) {
                                return const LoadingAnimation();
                              },
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) => WatchingAlert(
                                        show: show,
                                        userId: userId,
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                                deleteFeature
                                    ? IconButton(
                                        onPressed: () {
                                          context
                                              .read<SupabaseCubit>()
                                              .removeShow(
                                                userId: userId,
                                                showid: show.id,
                                              );
                                        },
                                        icon: const Icon(Icons.delete),
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
