import 'package:flutter/material.dart';
import 'package:monster_dex/application/bounties/screens/bounties_screen.dart';
import 'package:monster_dex/application/player_monsters/screens/player_monsters_screen.dart';

import 'custom_icons.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        AppBar(
          title: Text('Select'),
          automaticallyImplyLeading: false,
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.menu_book),
          title: Text('Main menu'),
          onTap: () =>
              Navigator.of(context).pushNamed('/'),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.currency_bitcoin),
          title: Text('Bounties history'),
          onTap: () =>
              Navigator.of(context).pushNamed(BountiesScreen.routeName),
        ),
        Divider(),
        ListTile(
          leading: Icon(CustomIcons.skull),
          title: Text('Your monsters'),
          onTap: () =>
              Navigator.of(context).pushNamed(PlayerMonstersScreen.routeName),
        ),
      ],
    ));
  }
}
