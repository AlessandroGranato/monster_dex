import 'package:flutter/material.dart';
import 'package:monster_dex/application/bounties/screens/bounties_screen.dart';
import 'package:monster_dex/application/collect_bounty/screens/collect_bounty.dart';
import 'package:monster_dex/application/player_monsters/screens/edit_monster_screen.dart';
import 'package:monster_dex/application/player_monsters/screens/player_monsters_screen.dart';
import 'package:monster_dex/providers/bounties.dart';

import 'package:provider/provider.dart';
import './application/monsters_overview/screens/monsters_overview_screen.dart';
import '/providers/monsters.dart';
import 'application/monster_detail/screens/monster_detail_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Monsters()),
        ChangeNotifierProvider(create: (context) => Bounties()),
      ],
      child: MaterialApp(
        title: 'MonsterDex',
        theme: ThemeData(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: Colors.purple,
                secondary: Colors.deepOrange,
              ),
          textTheme: const TextTheme(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
        home: MonstersOverviewScreen(),
        routes: {
          MonsterDetailScreen.routeName: (ctx) => MonsterDetailScreen(),
          CollectBounty.routeName: (ctx) => CollectBounty(),
          BountiesScreen.routeName: (ctx) => BountiesScreen(),
          PlayerMonstersScreen.routeName: (ctx) => PlayerMonstersScreen(),
          EditMonsterScreen.routeName: (ctx) => EditMonsterScreen(),
        },
      ),
    );
  }
}
