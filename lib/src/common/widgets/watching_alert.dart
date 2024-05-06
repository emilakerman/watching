import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watching/src/src.dart';

class WatchingAlert extends StatelessWidget {
  const WatchingAlert({
    required this.showid,
    required this.userId,
    super.key,
  });
  final int showid;
  final int userId;
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final SupabaseServices supabaseServices = SupabaseServices(
      supabaseRepository: SupabaseRepository(),
    );
    return AlertDialog(
      content: BlocProvider(
        create: (context) => SupabaseCubit(
          supabaseServices: supabaseServices,
        ),
        child: BlocBuilder<SupabaseCubit, SupabaseCubitState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                children: [LoadingAnimation()],
              );
            }
            if (state.isSuccess) {
              // Future.delayed(Duration(seconds: 2), () {
              //   Navigator.of(context).pop();
              // });
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
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Select show status:", style: textStyle.titleLarge),
                ElevatedButton(
                  onPressed: () {
                    context.read<SupabaseCubit>().addNewShow(
                          userId: userId,
                          showid: showid,
                          showStatus: 'watching',
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
                        );
                  },
                  child: const Text("Completed"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
