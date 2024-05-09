import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:watching/src/features/shows/cubits/cubits.dart';

import 'navigation.dart';

class HamburgerMenu extends StatelessWidget {
  const HamburgerMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String? removeAfterAt(String input) {
      final RegExp exp = RegExp(r"^(.*?)(@.*)?$");
      return exp.firstMatch(input)?.group(1) ?? "";
    }

    return BlocBuilder<AuthCubit, AuthCubitState>(
      builder: (context, state) {
        return ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: SizedBox(
                height: 50,
                width: 50,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      child: Center(
                        child: Text(
                            '${state.user?.email?.toUpperCase()[0] ?? ""}'),
                      ),
                    ),
                    Flexible(
                      child: ListTile(
                        title: Text(
                          '${state.user?.displayName ?? removeAfterAt(state.user?.email ?? "")}',
                        ),
                        onTap: null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            const ListTile(
              title: Text('Browse'),
              onTap: null,
            ),
            const MenuDivider(),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {},
            ),
            const MenuDivider(),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search'),
              onTap: () {
                if (!context.mounted) return;
                Navigator.of(context).pop();
                context.pushNamed(WatchingRoutesNames.discover);
              },
            ),
            const MenuDivider(),
            ListTile(
              leading: const Icon(Icons.tv),
              title: const Text('Watching'),
              onTap: () {
                if (!context.mounted) return;
                Navigator.of(context).pop();
                context.goNamed(WatchingRoutesNames.watching);
              },
            ),
            const MenuDivider(),
            ListTile(
              leading: const Icon(Icons.done),
              title: const Text('Completed'),
              onTap: () {
                if (!context.mounted) return;
                Navigator.of(context).pop();
                context.goNamed(WatchingRoutesNames.completed);
              },
            ),
            const MenuDivider(),
            ListTile(
              leading: const Icon(Icons.next_plan_outlined),
              title: const Text('Plan to Watch'),
              onTap: () {
                if (!context.mounted) return;
                Navigator.of(context).pop();
                context.goNamed(WatchingRoutesNames.planToWatch);
              },
            ),
            const MenuDivider(),
            ListTile(
              leading: const Icon(Icons.featured_play_list_outlined),
              title: const Text('Featured'),
              onTap: () {
                if (!context.mounted) return;
                Navigator.of(context).pop();
                context.goNamed(WatchingRoutesNames.featured);
              },
            ),
            const MenuDivider(),
            ListTile(
              leading: const Icon(Icons.leaderboard),
              title: const Text('Leaderboard'),
              onTap: () {
                if (!context.mounted) return;
                Navigator.of(context).pop();
                context.goNamed(WatchingRoutesNames.leaderboard);
              },
            ),
          ],
        );
      },
    );
  }
}

class MenuDivider extends StatelessWidget {
  const MenuDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Divider(
        height: 1,
      ),
    );
  }
}
