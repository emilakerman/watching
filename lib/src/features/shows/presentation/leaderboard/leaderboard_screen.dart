import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:watching/core/core.dart';
import 'package:watching/src/features/profile/profile.dart';
import 'package:watching/src/src.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<LeaderboardCubit>().fetchAllPublicUsers();
    return BlocBuilder<LeaderboardCubit, LeaderboardCubitState>(
      builder: (context, state) {
        return Scaffold(
          body: state.isLoading
              ? const LoadingAnimation()
              : state.isError
                  ? Center(
                      child: Text(state.errorMessage ?? 'An error occurred'),
                    )
                  : kIsWeb
                      ? Center(
                          child: Container(
                            color: Colors.grey[900],
                            width: 700,
                            child: LeaderList(
                              state: state,
                            ),
                          ),
                        )
                      : LeaderList(
                          state: state,
                        ),
        );
      },
    );
  }
}

class LeaderList extends StatelessWidget {
  const LeaderList({
    required this.state,
    super.key,
  });
  final LeaderboardCubitState state;
  @override
  Widget build(BuildContext context) {
    String? imageUrl;

    const FirebaseStorageRepository firebaseStorageRepo =
        FirebaseStorageRepository();
    return ListView.builder(
      itemCount: state.users?.length ?? 0,
      itemBuilder: (context, index) {
        final user = state.users![index];
        return ListTile(
          onTap: () => context.goNamed(
            WatchingRoutesNames.profile,
            pathParameters: {
              'userId': user.userId.toString(),
            },
          ),
          leading: FutureBuilder(
            future: firebaseStorageRepo.getImageURL(
              imageName: user.userId.toString(),
            ),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                imageUrl = snapshot.data;
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 40,
                  width: 40,
                  child: LoadingAnimationColor(),
                );
              }
              if (imageUrl == null)
                return CircleAvatar(
                  backgroundColor: user.color,
                  child: Text(
                    user.nickname.isNotEmpty ? user.nickname[0] : 'A',
                  ),
                );
              return CircleAvatar(
                backgroundColor: user.color,
                child: ClipOval(
                  child: CachedNetworkImage(
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    imageUrl: imageUrl ?? 'https://via.placeholder.com/150',
                    progressIndicatorBuilder: (context, url, progress) {
                      return const LoadingAnimationColor();
                    },
                  ),
                ),
              );
            },
          ),
          title: Text(
            user.nickname != '' ? user.nickname : 'Anonymous User',
          ),
          subtitle: Text(
            'Completed Shows: ${user.completedShows.length}',
          ),
        );
      },
    );
  }
}
