import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:watching/core/core.dart';
import 'package:watching/src/features/profile/data/data.dart';
import 'package:watching/src/src.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _imageUrl;

  Future<void> uploadImage({required int userId}) async {
    const FirebaseStorageRepository firebaseStorageRepo =
        FirebaseStorageRepository();
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      final String imageUrl = await firebaseStorageRepo.uploadImage(
        image: imageFile,
        userIdHashed: userId,
      );
      setState(() {
        _imageUrl = imageUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const FirebaseStorageRepository firebaseStorageRepo =
        FirebaseStorageRepository();
    final FirebaseAuthRepository firebaseAuthRepo = FirebaseAuthRepository();
    final int userId = firebaseAuthRepo.getUser()!.uid.hashCode;
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
                  FutureBuilder(
                    future: firebaseStorageRepo.getImageURL(
                      imageName: userId.toString(),
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        _imageUrl = snapshot.data;
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 400,
                          child: LoadingAnimation(),
                        );
                      }
                      if (_imageUrl == null)
                        return const SizedBox(
                          height: 400,
                        );
                      return CachedNetworkImage(
                        width: double.infinity,
                        height: 400,
                        fit: BoxFit.cover,
                        imageUrl:
                            _imageUrl ?? 'https://via.placeholder.com/150',
                        progressIndicatorBuilder: (context, url, progress) {
                          return const LoadingAnimation();
                        },
                      );
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Theme.of(context).scaffoldBackgroundColor,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  TopButtonRow(userId: userId, uploadImage: uploadImage),
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
                        return Center(
                          child: LoadingAnimationWidget.discreteCircle(
                            color: Colors.purple[900]!,
                            size: 40,
                          ),
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          Text(
                            "Favorites",
                            style: textTheme.displayLarge,
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
                        return Center(
                          child: LoadingAnimationWidget.discreteCircle(
                            color: Colors.purple[900]!,
                            size: 40,
                          ),
                        );
                      }
                      void calculateBadges() {
                        switch (snapshot.data?.length ?? 1) {
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
                          Text(
                            "Badges",
                            style: textTheme.displayLarge,
                          ),
                          const SizedBox(height: 3),
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

class BottomTextColumn extends StatelessWidget {
  const BottomTextColumn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final LocationServies locationServies = LocationServies();
    return Positioned(
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, bottom: 15),
        child: BlocSelector<SettingsCubit, SettingsCubitState, Settings?>(
          selector: (state) {
            return state.getUserById();
          },
          builder: (context, user) {
            if (user?.nickname == null) return const LoadingAnimation();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user?.nickname ?? 'Anonymous user'}',
                  style: textTheme.displayLarge,
                ),
                FutureBuilder<String?>(
                  future: locationServies.newGetLocation(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.grey,
                        size: 30,
                      );
                    } else if (snapshot.hasError) {
                      return const SizedBox.shrink();
                    } else if (snapshot.hasData) {
                      return Text('📍 Location: ${snapshot.data}');
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
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
    required this.userId,
    required this.uploadImage,
    super.key,
  });
  final int userId;
  final Function uploadImage;
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
                onPressed: () => uploadImage(
                  userId: userId,
                ),
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
