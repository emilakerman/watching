import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:watching/core/core.dart';
import 'package:watching/src/features/profile/data/data.dart';
import 'package:watching/src/src.dart';
import 'package:watching/utils/hash_converter.dart';
import "file_operations_io.dart"
    if (dart.library.html) "file_operations_html.dart";

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    required this.userId,
    super.key,
  });
  final int userId;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _imageUrl;

  Future<void> uploadImage({required int userId}) async {
    const FirebaseStorageRepository firebaseStorageRepo =
        FirebaseStorageRepository();
    const FirebaseStorageWebRepo firebaseStorageWebRepo =
        FirebaseStorageWebRepo();
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (!kIsWeb) {
      if (pickedFile != null) {
        final imageFile = await getFileFromImagePicker(pickedFile);
        final String imageUrl = await firebaseStorageRepo.uploadImage(
          image: imageFile,
          userIdHashed: userId,
        );
        if (!context.mounted) return;
        setState(() {
          _imageUrl = imageUrl;
        });
      }
    } else if (kIsWeb) {
      if (pickedFile != null) {
        final imageFile = await getFileFromImagePicker(pickedFile);
        final String imageUrl = await firebaseStorageWebRepo.uploadImage(
          image: imageFile,
          userIdHashed: userId,
        );
        if (!context.mounted) return;
        setState(() {
          _imageUrl = imageUrl;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const FirebaseStorageRepository firebaseStorageRepo =
        FirebaseStorageRepository();
    final FirebaseAuthRepository firebaseAuthRepo = FirebaseAuthRepository();
    final int userId = widget.userId;
    return BlocProvider(
      create: (context) => AuthCubit(
        firebaseAuthRepository: firebaseAuthRepo,
      ),
      child: Scaffold(
        body: Center(
          child: SizedBox(
            width: kIsWeb ? 700 : double.infinity,
            child: SingleChildScrollView(
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
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox(
                              height: 430,
                              child: LoadingAnimationColor(),
                            );
                          }
                          if (_imageUrl == null)
                            return const SizedBox(
                              height: 430,
                            );
                          return CachedNetworkImage(
                            width: double.infinity,
                            height: 430,
                            fit: BoxFit.cover,
                            imageUrl:
                                _imageUrl ?? 'https://via.placeholder.com/150',
                            progressIndicatorBuilder: (context, url, progress) {
                              return const LoadingAnimationColor();
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
                      TopButtonRow(
                        userId: userId,
                        uploadImage: uploadImage,
                      ),
                      BottomTextColumn(userId: userId),
                    ],
                  ),
                  RowOfStats(userId: userId),
                  BadgesCard(userId: userId),
                  FavoritesCard(userId: userId),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FavoritesCard extends StatelessWidget {
  const FavoritesCard({
    required this.userId,
    super.key,
  });
  final int userId;
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
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
            userId: userId,
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
                        return const LoadingAnimationColor();
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
                              separatorBuilder: (context, _) =>
                                  const SizedBox(width: 10),
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data?.length ?? 0,
                              padding: const EdgeInsets.only(bottom: 10),
                              itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  context
                                      .read<ShowCubit>()
                                      .getFavoritesByUserId(userId: userId)
                                      .then(
                                        (_) => context.pushNamed(
                                          WatchingRoutesNames.show,
                                          pathParameters: {
                                            'showId':
                                                '${snapshot.data?[index].id}',
                                          },
                                        ),
                                      );
                                },
                                child: CachedNetworkImage(
                                  imageUrl:
                                      snapshot.data?[index].image?.medium ??
                                          'https://via.placeholder.com/150',
                                  progressIndicatorBuilder:
                                      (context, url, progress) {
                                    return const LoadingAnimationColor();
                                  },
                                ),
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

class BadgesCard extends StatefulWidget {
  const BadgesCard({
    required this.userId,
    super.key,
  });
  final int userId;

  @override
  State<BadgesCard> createState() => _BadgesCardState();
}

class _BadgesCardState extends State<BadgesCard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<int> calculateBadges(length) {
      List<int> returnedValue;
      switch (length ?? 1) {
        case >= 1 && < 10:
          returnedValue = [1];
        case >= 10 && < 50:
          returnedValue = [1, 10];
        case >= 50 && < 100:
          returnedValue = [1, 10, 50];
        case >= 100 && < 200500:
          returnedValue = [1, 10, 50, 100];
        case >= 200 && < 500:
          returnedValue = [1, 10, 50, 100, 200];
        case >= 500 && < 1000:
          returnedValue = [1, 10, 50, 100, 200, 500];
        case >= 1000:
          returnedValue = [1, 10, 50, 100, 200, 500, 1000];
        default:
          returnedValue = [];
      }
      return returnedValue;
    }

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
            userId: widget.userId,
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
                      List<int> badges = [];
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const LoadingAnimationColor();
                      }
                      badges = calculateBadges(snapshot.data?.length);
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
                                return SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                      Tab(
                                        child: GestureDetector(
                                          onTap: () => _tabController.animateTo(
                                            1,
                                          ),
                                          child: Image.asset(
                                            'assets/images/${badges[index]}.png',
                                            height: 50,
                                            width: 50,
                                          ),
                                        ),
                                      ),
                                      Tab(
                                        child: GestureDetector(
                                          onTap: () => _tabController.animateTo(
                                            0,
                                          ),
                                          child: CircleAvatar(
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
                                          ),
                                        ),
                                      ),
                                    ],
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
    required this.userId,
    super.key,
  });
  final int userId;
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
            userId: userId,
          );
          final Future<List<Show>> watchingShows = showService.getAllWatching(
            userId: userId,
          );
          final Future<List<Show>> planToWatchShows =
              showService.getAllPlanToWatch(
            userId: userId,
          );
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: IntrinsicHeight(
              child: FutureBuilder(
                future: completedShows,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingAnimationColor();
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          FutureBuilder(
                            future: watchingShows,
                            builder: (context, watchingShows) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const LoadingAnimationColor();
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
                                return const LoadingAnimationColor();
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
    required this.userId,
    super.key,
  });
  final int userId;
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
            return state.getUserById(userId);
          },
          builder: (context, user) {
            if (user?.nickname == null) return const LoadingAnimationColor();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user?.nickname ?? 'Anonymous user'}',
                  style: textTheme.displayLarge,
                ),
                !kIsWeb
                    ? FutureBuilder<String?>(
                        future: locationServies.newGetLocation(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const LoadingAnimationDots();
                          } else if (snapshot.hasError) {
                            return const SizedBox.shrink();
                          } else if (snapshot.hasData) {
                            return Text('📍 Location: ${snapshot.data}');
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      )
                    : const SizedBox.shrink(),
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
    final String id =
        customStringHash(firebaseAuthRepo.getUser()!.uid).toString();
    final bool notYou =
        userId != customStringHash(FirebaseAuthRepository().getUser()!.uid);
    return Padding(
      padding:
          const EdgeInsets.only(top: kIsWeb ? 20 : 40, left: 15, right: 15),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Colors.grey[600],
                  ),
                ),
                onPressed: () {
                  context.read<ShowCubit>().emptyState().whenComplete(
                        () => context.goNamed(
                          WatchingRoutesNames.discover,
                        ),
                      );
                },
                icon: const Icon(Icons.close),
              ),
              const Spacer(),
              !notYou
                  ? IconButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Colors.grey[600],
                        ),
                        iconColor: const WidgetStatePropertyAll(
                          Colors.white,
                        ),
                      ),
                      onPressed: () => uploadImage(
                        userId: userId,
                      ),
                      icon: const Icon(Icons.edit),
                    )
                  : const SizedBox.shrink(),
              kIsWeb ? const SizedBox(width: 10) : const SizedBox.shrink(),
              !notYou
                  ? IconButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Colors.grey[600],
                        ),
                        iconColor: const WidgetStatePropertyAll(
                          Colors.white,
                        ),
                      ),
                      onPressed: () => context.goNamed(
                        WatchingRoutesNames.settings,
                        pathParameters: {
                          'userId': id,
                        },
                      ),
                      icon: const Icon(Icons.settings),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }
}
