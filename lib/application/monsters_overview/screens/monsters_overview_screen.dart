import 'package:flutter/material.dart';
import 'package:monster_dex/application/collect_bounty/screens/collect_bounty.dart';
import 'package:monster_dex/application/monsters_overview/widgets/badge.dart';
import 'package:monster_dex/providers/monsters.dart';
import 'package:monster_dex/utils/app_drawer.dart';
import 'package:provider/provider.dart';
import '../../../utils/custom_icons.dart';
import '../widgets/monsters_grid.dart';

class MonstersOverviewScreen extends StatefulWidget {
  const MonstersOverviewScreen({Key? key}) : super(key: key);

  @override
  State<MonstersOverviewScreen> createState() => _MonstersOverviewScreenState();
}

class _MonstersOverviewScreenState extends State<MonstersOverviewScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isLoading = true;
      Provider.of<Monsters>(context)
          .fetchMonsters()
          .then((_) => _isLoading = false);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var monsters = Provider.of<Monsters>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Monsters'),
        actions: [
          Badge(
            child: IconButton(
                icon: Icon(CustomIcons.skull, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pushNamed(CollectBounty.routeName);
                }),
            value: monsters.getDefeatedMonsters.length.toString(),
            color: Colors.red,
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : MonstersGrid(),
    );
  }
}
