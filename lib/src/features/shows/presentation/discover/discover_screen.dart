import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watching/src/src.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShowCubit(
        showService: ShowService(
          tvMazeRepository: TvMazeRepository(),
        ),
      ),
      child: BlocBuilder<ShowCubit, ShowCubitState>(
        builder: (context, ShowCubitState state) {
          if (state.isLoading) {
            return const LoadingAnimation();
          } else if (state.isError) {
            return const Center(
              child: Text('Error fetching shows'),
            );
          } else {
            return ListView.builder(
              itemCount: state.shows.length,
              itemBuilder: (context, index) {
                final show = state.shows[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      show.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
