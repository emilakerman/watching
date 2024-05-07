import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watching/src/src.dart';

class WatchingScreen extends StatelessWidget {
  const WatchingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(
        firebaseAuthRepository: FirebaseAuthRepository(),
      ),
      child: BlocBuilder<AuthCubit, AuthCubitState>(
        builder: (context, state) {
          final ShowService showService = ShowService(
            tvMazeRepository: TvMazeRepository(),
          );
          final Future<List<Show>> watchingShows = showService.getAllWatching(
            userId: state.user!.uid.hashCode,
          );
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder(
                  future: watchingShows,
                  builder: (context, watchingShows) {
                    if (watchingShows.connectionState ==
                        ConnectionState.waiting) {
                      return const LoadingAnimation();
                    }
                    return Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    "You are watching ${watchingShows.data?.length} shows!",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SearchView(shows: watchingShows.data as List<Show>),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
