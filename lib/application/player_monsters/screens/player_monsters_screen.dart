import 'package:flutter/material.dart';
import 'package:monster_dex/application/player_monsters/screens/edit_monster_screen.dart';
import 'package:monster_dex/application/player_monsters/widgets/player_monster_item.dart';
import 'package:monster_dex/providers/monsters.dart';
import 'package:monster_dex/utils/app_drawer.dart';
import 'package:provider/provider.dart';

class PlayerMonstersScreen extends StatelessWidget {
  static String routeName = "/player-monsters";
  const PlayerMonstersScreen({Key? key}) : super(key: key);

  Future<void> _refreshMonsters(BuildContext context) async {
    await Provider.of<Monsters>(context, listen: false).fetchMonsters();
  }

  @override
  Widget build(BuildContext context) {
    var monsters = Provider.of<Monsters>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your monsters'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditMonsterScreen.routeName);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshMonsters(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: monsters.getMonsters.length,
            itemBuilder: (context, index) => PlayerMonsterItem(
              monsterId: monsters.getMonsters[index].id,
              monsterName: monsters.getMonsters[index].name,
              monsterImageUrl: monsters.getMonsters[index].imageUrl,
            ),
          ),
        ),
      ),
    );
  }
}
