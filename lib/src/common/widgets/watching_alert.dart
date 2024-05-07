import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watching/src/src.dart';

class WatchingAlert extends StatelessWidget {
  const WatchingAlert({
    required this.showid,
    required this.userId,
    required this.show,
    super.key,
  });
  final int showid;
  final int userId;
  final Show show;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return AlertDialog(
      content: BlocBuilder<SupabaseCubit, SupabaseCubitState>(
        builder: (context, state) {
          if (state.isLoading) {
            Navigator.of(context).pop();
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Select show status:", style: textStyle.titleLarge),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  context.read<SupabaseCubit>().addNewShow(
                        userId: userId,
                        showid: showid,
                        showStatus: 'watching',
                        show: show,
                      );
                },
                child: const Text("Watching"),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<SupabaseCubit>().addNewShow(
                        userId: userId,
                        showid: showid,
                        showStatus: 'plan-to-watch',
                        show: show,
                      );
                },
                child: const Text("Plan to Watch"),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<SupabaseCubit>().addNewShow(
                        userId: userId,
                        showid: showid,
                        showStatus: 'completed',
                        show: show,
                      );
                },
                child: const Text("Completed"),
              ),
            ],
          );
        },
      ),
    );
  }
}
