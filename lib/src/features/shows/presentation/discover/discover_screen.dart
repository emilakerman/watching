import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watching/src/src.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final List<Show> filteredList = [];
  final searchController = TextEditingController();
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

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
                  Expanded(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          show.name,
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          show.language,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          show.genres.join(', '),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
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
                                        progressIndicatorBuilder:
                                            (context, url, progress) {
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
                  ),
                ],
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
}
