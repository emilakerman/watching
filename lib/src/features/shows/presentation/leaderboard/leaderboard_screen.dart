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
                  : ListView.builder(
                      itemCount: state.users?.length ?? 0,
                      itemBuilder: (context, index) {
                        final user = state.users![index];
                        return ListTile(
                          title: Text(
                            user.nickname != ''
                                ? user.nickname
                                : 'Anonymous User',
                          ),
                          subtitle: Text(
                            'Completed Shows: ${user.completedShows.length}',
                          ),
                        );
                      },
                    ),
        );
      },
    );
  }
}
