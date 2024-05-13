import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watching/src/src.dart';

import '../../../../../config/config.dart';

class WatchingScreen extends StatelessWidget {
  const WatchingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<SupabaseCubit>().getAllWatching();
    return Scaffold(
      body: BlocBuilder<SupabaseCubit, SupabaseCubitState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const LoadingAnimation();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              "You are watching ${state.show.length} ${state.show.length != 1 ? 'shows' : 'show'}!",
                              style: Theme.of(context).textTheme.displayLarge,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SearchView(
                      shows: state.show,
                      listType: ListType.watching,
                      deleteFeature: true,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
