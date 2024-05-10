import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watching/config/enums/enums.dart';
import 'package:watching/src/features/authentication/authentication.dart';
import 'package:watching/src/features/shows/cubits/leaderboard_cubit.dart';
import 'package:watching/src/features/shows/shows.dart';

class WatchingProviders extends StatelessWidget {
  const WatchingProviders({
    required this.child,
    required this.environment,
    super.key,
  });
  final Widget child;
  final WatchingEnvironment environment;
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // ... Services ...
        RepositoryProvider(
          create: (context) => SupabaseServices(
            supabaseRepository: SupabaseRepository(),
          ),
        ),
        RepositoryProvider(
          create: (context) => ShowService(
            tvMazeRepository: TvMazeRepository(),
          ),
        ),
        RepositoryProvider(
          create: (context) => FirebaseAuthRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ShowCubit(
              showService: context.read<ShowService>(),
            ),
          ),
          BlocProvider(
            create: (context) => SupabaseCubit(
              supabaseServices: context.read<SupabaseServices>(),
            ),
          ),
          BlocProvider(
            create: (context) => AuthCubit(
              firebaseAuthRepository: context.read<FirebaseAuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => LeaderboardCubit(
              supabaseServices: context.read<SupabaseServices>(),
            ),
          ),
          BlocProvider(
            create: (context) => SettingsCubit(
              supabaseServices: context.read<SupabaseServices>(),
            ),
          ),
        ],
        child: child,
      ),
    );
  }
}
