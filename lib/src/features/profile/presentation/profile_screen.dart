import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:watching/core/core.dart';
import 'package:watching/src/src.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuthRepository firebaseAuthRepo = FirebaseAuthRepository();
    return BlocProvider(
      create: (context) => AuthCubit(
        firebaseAuthRepository: firebaseAuthRepo,
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  CachedNetworkImage(
                    // TODO(Any): Replace imageUrl with user's profile image.
                    imageUrl:
                        'https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&fl=progressive&q=70&fm=jpg' ??
                            '',
                    progressIndicatorBuilder: (context, url, progress) {
                      return const LoadingAnimation();
                    },
                  ),
                  const GradientContainer(),
                  const TopButtonRow(),
                  const BottomTextColumn(),
                ],
              ),
              const RowOfStats(),
              const BadgesCard(),
              const FavoritesCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class FavoritesCard extends StatelessWidget {
  const FavoritesCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocProvider(
      create: (context) => AuthCubit(
        firebaseAuthRepository: FirebaseAuthRepository(),
      ),
      child: BlocBuilder<AuthCubit, AuthCubitState>(
        builder: (context, state) {
          final ShowService showService = ShowService(
            tvMazeRepository: TvMazeRepository(),
          );
          final Future<List<Show>> shows = showService.getFavoritesByUserId(
            userId: state.user!.uid.hashCode,
          );
          return SizedBox(
            height: 200,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: FutureBuilder(
                    future: shows,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const LoadingAnimation();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Favorites",
                                style: textTheme.displayLarge,
                              ),
                              // TODO(Any): Implement navigation to view all favorites or bottom sheet.
                              InkWell(
                                onTap: () => {},
                                child: Text(
                                  "View All",
                                  style: textTheme.displayMedium?.copyWith(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            "${snapshot.data?.length ?? 0} favorites",
                            style: textTheme.displayMedium,
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 10),
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data?.length ?? 0,
                              padding: const EdgeInsets.only(bottom: 10),
                              itemBuilder: (context, index) =>
                                  CachedNetworkImage(
                                imageUrl: snapshot.data?[index].image?.medium ??
                                    'https://via.placeholder.com/150',
                                progressIndicatorBuilder:
                                    (context, url, progress) {
                                  return const LoadingAnimation();
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class BadgesCard extends StatelessWidget {
  const BadgesCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocProvider(
      create: (context) => AuthCubit(
        firebaseAuthRepository: FirebaseAuthRepository(),
      ),
      child: BlocBuilder<AuthCubit, AuthCubitState>(
        builder: (context, state) {
          final ShowService showService = ShowService(
            tvMazeRepository: TvMazeRepository(),
          );
          final Future<List<Show>> completedShows = showService.getAllCompleted(
            userId: state.user!.uid.hashCode,
          );
          return SizedBox(
            height: 150,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: FutureBuilder(
                    future: completedShows,
                    builder: (context, snapshot) {
                      final List<int> badges = [];
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const LoadingAnimation();
                      }
                      void calculateBadges() {
                        switch (snapshot.data!.length) {
                          case >= 1:
                            badges.add(1);
                            break;
                          case >= 10:
                            badges.add(10);
                            break;
                          case >= 50:
                            badges.add(50);
                            break;
                          case >= 100:
                            badges.add(100);
                            break;
                          case >= 200:
                            badges.add(200);
                            break;
                          case >= 500:
                            badges.add(500);
                            break;
                          case >= 1000:
                            badges.add(1000);
                            break;
                          default:
                            break;
                        }
                      }

                      calculateBadges();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Badges",
                                style: textTheme.displayLarge,
                              ),
                              // TODO(Any): Implement navigation to view all badges or bottom sheet.
                              InkWell(
                                onTap: () => {},
                                child: Text(
                                  "View All",
                                  style: textTheme.displayMedium?.copyWith(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          // TODO(Any): Replace with real badges count.
                          Text(
                            "${badges.length} unlocked",
                            style: textTheme.displayMedium,
                          ),
                          Expanded(
                            child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 10),
                              scrollDirection: Axis.horizontal,
                              itemCount: badges.length,
                              itemBuilder: (context, index) {
                                // TODO(Any): Replace with real badges.
                                return CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Text(
                                    badges[index] != 1000
                                        ? badges[index].toString()
                                        : "1k",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class RowOfStats extends StatelessWidget {
  const RowOfStats({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocProvider(
      create: (context) => AuthCubit(
        firebaseAuthRepository: FirebaseAuthRepository(),
      ),
      child: BlocBuilder<AuthCubit, AuthCubitState>(
        builder: (context, state) {
          final ShowService showService = ShowService(
            tvMazeRepository: TvMazeRepository(),
          );
          final Future<List<Show>> completedShows = showService.getAllCompleted(
            userId: state.user!.uid.hashCode,
          );
          final Future<List<Show>> watchingShows = showService.getAllWatching(
            userId: state.user!.uid.hashCode,
          );
          final Future<List<Show>> planToWatchShows =
              showService.getAllPlanToWatch(
            userId: state.user!.uid.hashCode,
          );
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: IntrinsicHeight(
              child: FutureBuilder(
                future: completedShows,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingAnimation();
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // TODO(Any): Replace static numbers with real data, completed is done already.
                      Column(
                        children: [
                          FutureBuilder(
                            future: watchingShows,
                            builder: (context, watchingShows) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const LoadingAnimation();
                              }
                              return Text(
                                watchingShows.data?.length.toString() ?? "0",
                                textAlign: TextAlign.center,
                                style: textTheme.displayLarge,
                              );
                            },
                          ),
                          Text(
                            "Watching",
                            textAlign: TextAlign.center,
                            style: textTheme.displayMedium,
                          ),
                        ],
                      ),
                      VerticalDivider(
                        color: Colors.grey.withOpacity(0.5),
                        thickness: 2,
                      ),
                      Column(
                        children: [
                          FutureBuilder(
                            future: planToWatchShows,
                            builder: (context, planToWatchShows) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const LoadingAnimation();
                              }
                              return Text(
                                planToWatchShows.data?.length.toString() ?? "",
                                textAlign: TextAlign.center,
                                style: textTheme.displayLarge,
                              );
                            },
                          ),
                          Text(
                            "Plan To Watch",
                            textAlign: TextAlign.center,
                            style: textTheme.displayMedium,
                          ),
                        ],
                      ),
                      VerticalDivider(
                        color: Colors.grey.withOpacity(0.5),
                        thickness: 2,
                      ),
                      Column(
                        children: [
                          Text(
                            snapshot.data?.length.toString() ?? "",
                            textAlign: TextAlign.center,
                            style: textTheme.displayLarge,
                          ),
                          Text(
                            "Completed",
                            textAlign: TextAlign.center,
                            style: textTheme.displayMedium,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class GradientContainer extends StatelessWidget {
  const GradientContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350.0,
      decoration: BoxDecoration(
        color: Colors.white,
        gradient: LinearGradient(
          begin: FractionalOffset.topCenter,
          end: FractionalOffset.bottomCenter,
          colors: [
            Colors.grey.withOpacity(0.0),
            Colors.black,
          ],
          stops: const [0.0, 1.0],
        ),
      ),
    );
  }
}

class BottomTextColumn extends StatelessWidget {
  const BottomTextColumn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    String? removeAfterAt(String input) {
      final RegExp exp = RegExp(r"^(.*?)(@.*)?$");
      return exp.firstMatch(input)?.group(1) ?? "";
    }

    return Positioned(
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, bottom: 15),
        child: BlocBuilder<AuthCubit, AuthCubitState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${state.user?.displayName ?? removeAfterAt(state.user?.email ?? "")}',
                  style: textTheme.displayLarge,
                ),
                Text('${state.user?.email}'),
                const Text("📍Stockholm, Sweden"),
              ],
            );
          },
        ),
      ),
    );
  }
}

class TopButtonRow extends StatelessWidget {
  const TopButtonRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 55, left: 15, right: 15),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Colors.grey[600],
                  ),
                ),
                onPressed: context.pop,
                icon: const Icon(Icons.close),
              ),
              const Spacer(),
              IconButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Colors.grey[600],
                  ),
                  iconColor: const MaterialStatePropertyAll(
                    Colors.white,
                  ),
                ),
                onPressed: () {},
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Colors.grey[600],
                  ),
                  iconColor: const MaterialStatePropertyAll(
                    Colors.white,
                  ),
                ),
                onPressed: () => context.goNamed(WatchingRoutesNames.settings),
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
