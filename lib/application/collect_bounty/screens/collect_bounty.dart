//Monster-detail-screen
import 'package:flutter/material.dart';
import 'package:monster_dex/application/collect_bounty/widgets/collect_bounty_item.dart';
import 'package:monster_dex/application/monster_detail/widgets/pros_and_cons.dart';
import 'package:monster_dex/providers/bounties.dart';
import 'package:monster_dex/providers/bounty.dart';
import 'package:monster_dex/providers/monsters.dart';
import 'package:monster_dex/utils/app_drawer.dart';
import 'package:provider/provider.dart';
import '../../../providers/monster.dart';

class CollectBounty extends StatelessWidget {
  static const String routeName = '/collect-bounty-screen';
  const CollectBounty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var monsters = Provider.of<Monsters>(context);
    var bounties = Provider.of<Bounties>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Collect Bounties')),
      drawer: AppDrawer(),
      body: Column(children: [
        Card(
          margin: EdgeInsets.all(15),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Spacer(),
                Chip(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  label: Text(
                    '\$${monsters.getTotalBountyAmount().toString()}',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                CollectBountyButton(monsters: monsters, bounties: bounties),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: monsters.getDefeatedMonsters.length,
            itemBuilder: (context, i) => CollectBountyItem(
              monster: monsters.getDefeatedMonsters[i],
            ),
          ),
        )
      ]),
    );
  }
}

class CollectBountyButton extends StatefulWidget {
  const CollectBountyButton({
    Key? key,
    required this.monsters,
    required this.bounties,
  }) : super(key: key);

  final Monsters monsters;
  final Bounties bounties;

  @override
  State<CollectBountyButton> createState() => _CollectBountyButtonState();
}

class _CollectBountyButtonState extends State<CollectBountyButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.monsters.getTotalBountyAmount() <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await widget.bounties.addBounty(
                Bounty(
                  'Bounty_${DateTime.now()}',
                  widget.monsters.getDefeatedMonsters,
                  DateTime.now(),
                  widget.monsters.getTotalBountyAmount(),
                ),
              );
              widget.monsters.getDefeatedMonsters.forEach((element) {
                widget.monsters.changeDefeated(element.id, false);
              });
              setState(() {
                _isLoading = false;
              });
            },
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              'Collect Bounties!',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold),
            ),
    );
  }
}
