import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watching/src/src.dart';

class FavoriteAlert extends StatelessWidget {
  const FavoriteAlert({
    required this.userId,
    required this.show,
    super.key,
  });
  final int userId;
  final Show show;

  @override
  Widget build(BuildContext context) {
    final SupabaseServices supabaseServices = SupabaseServices(
      supabaseRepository: SupabaseRepository(),
    );
    final textStyle = Theme.of(context).textTheme;
    context.read<SupabaseCubit>().resetToInitialState();
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
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  supabaseServices.toggleFavoriteShow(
                    userId: userId,
                    showid: show.id,
                    isFavorite: true,
                  );
                },
                child: const Text("Add to Favorites"),
              ),
              !kIsWeb ? const SizedBox() : const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  supabaseServices.toggleFavoriteShow(
                    userId: userId,
                    showid: show.id,
                    isFavorite: false,
                  );
                },
                child: const Text("Remove from Favorites"),
              ),
              CupertinoButton(
                onPressed: Navigator.of(context).pop,
                child: const Text('Close Dialog'),
              ),
            ],
          );
        },
      ),
    );
  }
}
