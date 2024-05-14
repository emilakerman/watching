import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watching/src/src.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
    return ListView.builder(
      itemCount: state.users?.length ?? 0,
      itemBuilder: (context, index) {
        final user = state.users![index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: user.color,
            child: Text(
              user.nickname.isNotEmpty ? user.nickname[0] : 'A',
            ),
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
