import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/monster.dart';
import '../../../providers/monsters.dart';
import './monster_item.dart';

class MonstersGrid extends StatelessWidget {
  const MonstersGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var monstersData = Provider.of<Monsters>(context);
    List<Monster> monsters = monstersData.getMonsters;
    return GridView.builder(
      padding: EdgeInsets.all(10),
      itemCount: monsters.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.5 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: monsters[i],
        child: MonsterItem(),
      ),
    );
  }
}
