import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:watching/src/features/profile/presentation/mock_favorites.dart';
import 'package:watching/src/src.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuthRepository firebaseAuthRepo = FirebaseAuthRepository();
    final textTheme = Theme.of(context).textTheme;
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
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
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
                // TODO(Any): Replace with real badges count.
                Text(
                  "2 favorites",
                  style: textTheme.displayMedium,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(bottom: 15),
                    itemCount: mockFavorites.length,
                    itemBuilder: (context, index) {
                      // TODO(Any): Replace with real favorites.
                      return CachedNetworkImage(
                        imageUrl: mockFavorites[index],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
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
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
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
                  "4 unlocked",
                  style: textTheme.displayMedium,
                ),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      // TODO(Any): Replace with real badges.
                      return CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(
                          index.toString(),
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
            ),
          ),
        ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // TODO(Any): Replace static numbers with real data.
            Column(
              children: [
                Text(
                  "3",
                  textAlign: TextAlign.center,
                  style: textTheme.displayLarge,
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
                Text(
                  "14",
                  textAlign: TextAlign.center,
                  style: textTheme.displayLarge,
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
                  "78",
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
        ),
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
                onPressed: () {},
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
