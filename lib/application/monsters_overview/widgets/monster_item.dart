import 'package:flutter/material.dart';
import 'package:monster_dex/application/monster_detail/screens/monster_detail_screen.dart';
import 'package:monster_dex/utils/custom_icons.dart';
import 'package:provider/provider.dart';
import '../../../providers/monster.dart';
import '../../../providers/monsters.dart';

class MonsterItem extends StatelessWidget {
  const MonsterItem({Key? key}) : super(key: key);

  Image _retrieveMonsterImage(Monster m) {
    if (m.imageUrl == null || m.imageUrl.isEmpty || m.imageUrl == '') {
      return Image.asset(
        'assets/images/question_mark.png',
        fit: BoxFit.cover,
      );
    } else
      return Image.network(
        m.imageUrl,
        fit: BoxFit.cover,
      );
  }

  @override
  Widget build(BuildContext context) {
    var scaffoldMessenger = ScaffoldMessenger.of(context);
    var monster = Provider.of<Monster>(context);
    var monsters = Provider.of<Monsters>(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              MonsterDetailScreen.routeName,
              arguments: monster,
            );
          },
          child: _retrieveMonsterImage(monster),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(monster.name, textAlign: TextAlign.center),
          trailing: IconButton(
            icon: monster.isDefeated
                ? Icon(CustomIcons.skull, color: Colors.red.shade700)
                : Icon(CustomIcons.skull, color: Colors.grey),
            onPressed: () async {
              try {
                await monster.toggleDefeated();
              } catch (error) {
                print(error);
                scaffoldMessenger.showSnackBar(SnackBar(content: Text(error.toString())));
              }

              monsters.notifyListeners();
            },
          ),
        ),
      ),
    );
  }
}
