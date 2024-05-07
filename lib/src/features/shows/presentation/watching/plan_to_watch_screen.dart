import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watching/src/src.dart';

class PlanToWatchScreen extends StatelessWidget {
  const PlanToWatchScreen({super.key});

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
          final Future<List<Show>> planToWatchShows =
              showService.getAllPlanToWatch(
            userId: state.user!.uid.hashCode,
          );
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder(
                  future: planToWatchShows,
                  builder: (context, planToWatchShows) {
                    if (planToWatchShows.connectionState ==
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
                                    "You plan to watch ${planToWatchShows.data?.length} shows!",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SearchView(
                              shows: planToWatchShows.data as List<Show>),
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
