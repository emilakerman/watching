import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:watching/src/src.dart';

class WatchingAlert extends StatelessWidget {
  const WatchingAlert({
    required this.userId,
    required this.show,
    super.key,
  });
  final int userId;
  final Show show;
  @override
  Widget build(BuildContext context) {
    final SupabaseRepository supabaseRepository = SupabaseRepository();
    final textStyle = Theme.of(context).textTheme;
    context.read<SupabaseCubit>().resetToInitialState();
    final Future<String> existingStatus =
        supabaseRepository.checkIfShowExistsInSupabase(
      userId: userId,
      showid: show.id,
    );
    return AlertDialog(
      content: BlocBuilder<SupabaseCubit, SupabaseCubitState>(
        builder: (context, state) {
          if (state.isLoading)
            return const SizedBox(height: 100, child: LoadingAnimation());
          if (state.isSuccess) {
            Future.delayed(const Duration(milliseconds: 200), () {
              Navigator.of(context).pop();
            });
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline_outlined,
                        color: Colors.grey.withOpacity(0.3),
                        size: 100,
                      ),
                      Text(
                        'Added!',
                        style: textStyle.titleLarge,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return FutureBuilder<String>(
              future: existingStatus,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(height: 100, child: LoadingAnimation());
                }
                Logger().d(snapshot.data);
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Select show status:", style: textStyle.titleLarge),
                    const SizedBox(),
                    const SizedBox(height: 15),
                    if (snapshot.data != 'watching')
                      ElevatedButton(
                        onPressed: () {
                          context.read<SupabaseCubit>().addNewShow(
                                userId: userId,
                                showid: show.id,
                                showStatus: 'watching',
                                show: show,
                              );
                        },
                        child: const Text("Watching"),
                      ),
                    if (snapshot.data != 'plan-to-watch')
                      ElevatedButton(
                        onPressed: () {
                          context.read<SupabaseCubit>().addNewShow(
                                userId: userId,
                                showid: show.id,
                                showStatus: 'plan-to-watch',
                                show: show,
                              );
                        },
                        child: const Text("Plan to Watch"),
                      ),
                    if (snapshot.data != 'completed')
                      ElevatedButton(
                        onPressed: () {
                          context.read<SupabaseCubit>().addNewShow(
                                userId: userId,
                                showid: show.id,
                                showStatus: 'completed',
                                show: show,
                              );
                        },
                        child: const Text("Completed"),
                      ),
                    CupertinoButton(
                      onPressed: Navigator.of(context).pop,
                      child: const Text('Close Dialog'),
                    ),
                  ],
                );
              });
        },
      ),
    );
  }
}
