//Monster-detail-screen
import 'package:flutter/material.dart';
import 'package:monster_dex/application/monster_detail/widgets/pros_and_cons.dart';
import 'package:monster_dex/utils/app_drawer.dart';
import 'package:provider/provider.dart';
import '../../../providers/monster.dart';

class MonsterDetailScreen extends StatelessWidget {
  static const String routeName = '/monster-detail-screen';
  const MonsterDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider.value(
      value: ModalRoute.of(context)!.settings.arguments as Monster,
      child: Consumer<Monster>(builder: (context, monster, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('${monster.name}'),
          ),
          drawer: AppDrawer(),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.1,
                  ),
                  height: screenHeight * 0.4,
                  alignment: Alignment.center,
                  child: Image.network(monster.imageUrl),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                Container(
                  child: Text(
                    '${monster.name}',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                ProsAndCons(title: 'Strenghts', elements: monster.strengths),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                ProsAndCons(title: 'Weaknesses', elements: monster.weaknesses),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Notes',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Card(
                        child: Text(
                          " ${monster.notes}",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                Container(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'is defeated? ${monster.isDefeated}. (To put as image icon on top of monster image)',
                  ),
                ),
                IconButton(
                    onPressed: () {
                      monster.toggleDefeated();
                    },
                    icon: Icon(Icons.card_travel))
              ],
            ),
          ),
        );
      }),
    );
  }
}
