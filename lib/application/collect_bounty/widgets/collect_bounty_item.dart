import 'package:flutter/material.dart';
import 'package:monster_dex/providers/monsters.dart';
import 'package:provider/provider.dart';
import '../../../providers/monster.dart';

class CollectBountyItem extends StatelessWidget {
  final Monster monster;

  const CollectBountyItem({Key? key, required this.monster}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var monsters = Provider.of<Monsters>(context);
    return Dismissible(
      key: ValueKey(monster.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete, color: Colors.white, size: 40),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Monsters>(context, listen: false).changeDefeated(monster.id, false);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FittedBox(
                    child: Image.network(monster.imageUrl),
                  ),
                )),
            title: Text(monster.name),
            trailing: Text('\$${monster.bounty}'),
          ),
        ),
      ),
    );
  }
}
