import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  late TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShowCubit(
        showService: ShowService(
          tvMazeRepository: TvMazeRepository(),
        ),
      ),
      child: BlocBuilder<ShowCubit, ShowCubitState>(
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
                  SearchWidget(
                    searchController: searchController,
                    searchCallback: () {
                      setState(
                        () {
                          final shows = state.shows;
                          if (shows.isEmpty) return;
                          filteredList
                            ..clear()
                            ..addAll(
                              _matchShow(shows).toList(),
                            );
                        },
                      );
                    },
                  ),
                  SearchView(shows: shows),
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
                                          onPressed: () =>
                                              _tabController.animateTo(1),
                                          child: const Text(
                                            "Languages",
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
                                      itemCount: genres.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return ElevatedButton(
                                          onPressed: () {
                                            setState(
                                              () {
                                                selectedGenre =
                                                    genres[index].toString();
                                                final shows = state.shows;
                                                if (shows.isEmpty) return;
                                                filteredList
                                                  ..clear()
                                                  ..addAll(
                                                    _matchShowGenre(shows)
                                                        .toList(),
                                                  );
                                              },
                                            );
                                          },
                                          child: Text(
                                            style:
                                                const TextStyle(fontSize: 12),
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
                                            setState(
                                              () {
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
                                              },
                                            );
                                          },
                                          child: Text(
                                            style:
                                                const TextStyle(fontSize: 12),
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
      ),
    );
  }

  Iterable<Show> _matchShow(List<Show> shows) {
    return shows.where(
      (show) => show.name.toLowerCase().contains(
            searchController.text.toLowerCase(),
          ),
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
}

class SearchView extends StatelessWidget {
  const SearchView({
    required this.shows,
    super.key,
  });
  final List<Show> shows;
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: ListView.builder(
        itemCount: shows.length,
        itemBuilder: (context, index) {
          if (index >= shows.length) return null;
          final Show show = shows[index];
          return SizedBox(
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
                          imageUrl: show.image?.medium ?? '',
                          progressIndicatorBuilder: (context, url, progress) {
                            return const LoadingAnimation();
                          },
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.add),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.menu_open,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
