import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/monster.dart';
import 'pros_and_cons.dart';

class MonsterDetail extends StatelessWidget {
  const MonsterDetail({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
  }) : super(key: key);

  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    var monster = Provider.of<Monster>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('${monster.name}'),
        ),
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
              IconButton(onPressed: (){
                monster.toggleDefeated();
              }, icon: Icon(Icons.card_travel))
            ],
          ),
        ),
      );
  }
}


