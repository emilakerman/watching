import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:watching/src/features/authentication/authentication.dart';
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

    return BlocProvider(
      create: (context) => AuthCubit(
        firebaseAuthRepository: FirebaseAuthRepository(),
      ),
      child: BlocBuilder<AuthCubit, AuthCubitState>(
        builder: (context, state) {
          return ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15),
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
              SizedBox(height: 25),
              ListTile(
                title: Text('Browse'),
                onTap: null,
              ),
              MenuDivider(),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {},
              ),
              MenuDivider(),
              ListTile(
                leading: Icon(Icons.search),
                title: Text('Search'),
                onTap: () {
                  Navigator.of(context).pop();
                  context.pushNamed(WatchingRoutesNames.discover);
                },
              ),
              MenuDivider(),
              ListTile(
                leading: Icon(Icons.tv),
                title: Text('Watching'),
                onTap: () {
                  Navigator.of(context).pop();
                  context.goNamed(WatchingRoutesNames.watching);
                },
              ),
              MenuDivider(),
              ListTile(
                leading: Icon(Icons.done),
                title: Text('Completed'),
                onTap: () {
                  Navigator.of(context).pop();
                  context.goNamed(WatchingRoutesNames.completed);
                },
              ),
              MenuDivider(),
              ListTile(
                leading: Icon(Icons.next_plan_outlined),
                title: Text('Plan to Watch'),
                onTap: () {
                  Navigator.of(context).pop();
                  context.goNamed(WatchingRoutesNames.planToWatch);
                },
              ),
            ],
          );
        },
      ),
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
