import 'package:flutter/material.dart';
import 'package:monster_dex/application/player_monsters/screens/edit_monster_screen.dart';
import 'package:monster_dex/providers/monster.dart';
import 'package:monster_dex/providers/monsters.dart';
import 'package:provider/provider.dart';

class PlayerMonsterItem extends StatelessWidget {
  final String monsterId;
  final String monsterName;
  final String monsterImageUrl;

  const PlayerMonsterItem({
    Key? key,
    required this.monsterId,
    required this.monsterName,
    required this.monsterImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scaffoldMessenger = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(monsterImageUrl)),
      title: Text(monsterName),
      trailing: Container(
        width: 100,
        child: Row(children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditMonsterScreen.routeName,
                  arguments: {'monsterId': monsterId});
            },
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () async {
              try {
                await Provider.of<Monsters>(context, listen: false).deleteMonster(monsterId);
              } catch (error) {
                scaffoldMessenger
                    .showSnackBar(SnackBar(content: Text(error.toString())));
              }
            },
            icon: Icon(Icons.delete),
            color: Theme.of(context).errorColor,
          ),
        ]),
      ),
    );
  }
}
