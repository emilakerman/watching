import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'navigation.dart';

class HamburgerMenu extends StatelessWidget {
  const HamburgerMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                  backgroundImage: AssetImage(
                    'assets/images/default_avatar.png',
                  ),
                ),
                Flexible(
                  child: ListTile(
                    title: Text('Person Name'),
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
            context.goNamed(WatchingRoutesNames.discover);
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
          onTap: null,
        ),
        MenuDivider(),
        ListTile(
          leading: Icon(Icons.next_plan_outlined),
          title: Text('Plan to Watch'),
          onTap: null,
        ),
      ],
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
