import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:monster_dex/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:monster_dex/utils/exceptions/http_exception.dart';
import 'dart:convert';
import 'monster.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class Monsters with ChangeNotifier {
  
  String? dbUrl = dotenv.env['DB_URL'];

  List<Monster> _items = [
    Monster(
        id: 'm1',
        name: 'Goblin',
        strengths: ['They only attack in group', 'Good in dungeons'],
        weaknesses: ['weak creatures', 'Small weapons'],
        notes: 'They are always evil, no matter how they act',
        imageUrl:
            'https://toppng.com/uploads/preview/fantastic-bestiary-goblin-11549476367tqknfco8yo.png',
        isDefeated: false,
        bounty: 10.0),
    Monster(
        id: 'm2',
        name: 'Mimic',
        strengths: ['Suprise effect', 'Heavy armored'],
        weaknesses: ['Low mobility'],
        notes: 'The rarest the chest, the strongest the Mimic',
        imageUrl:
            'https://e7.pngegg.com/pngimages/587/952/png-clipart-dungeons-dragons-mimic-monster-manual-youtube-role-playing-game-youtube-purple-video-game.png',
        isDefeated: false,
        bounty: 20.0),
    Monster(
        id: 'm3',
        name: 'Orc',
        strengths: ['Physical strenght', 'Horrific'],
        weaknesses: ['Not so smart', 'Not so organized'],
        notes: 'Brutish, aggressive, ugly, and malevolent race of monsters',
        imageUrl:
            'https://purepng.com/public/uploads/large/purepng.com-orcorchumanoid-creaturefantasyorcs-1701527783448um8rb.png',
        isDefeated: false,
        bounty: 30.0),
    Monster(
        id: 'm4',
        name: 'Bugo',
        strengths: ['Natural shield', 'Both acquatic and terrain'],
        weaknesses: ['???'],
        notes: 'Usually calm, but extremely territorial',
        imageUrl:
            'https://i1.wp.com/acquariocomefare.com/wp-content/uploads/2018/09/tartarughe-di-acqua-dolce.jpg?fit=700%2C395&ssl=1',
        isDefeated: false,
        bounty: 99999.9),
  ];

  

  List<Monster> get getMonsters {
    return [..._items];
  }

  List<Monster> get getDefeatedMonsters {
    return _items.where((element) => element.isDefeated).toList();
  }

  Monster? findById(String id) {
    return _items.firstWhereOrNull((element) => element.id == id);
  }

  Future<void> fetchMonsters() async {
    try {
      final url = Uri.parse('${dbUrl}monsters.json');
      print('url: ${url.toString()}');
      var response = await http.get(url);
      print('fetchMonsters() called');
      print(json.decode(response.body));

      var fetchedData = json.decode(response.body) as Map<String, dynamic>;
      List<Monster> loadedMonsters = [];
      fetchedData.forEach((key, value) {
        loadedMonsters.add(Monster.fromJsonKeyMap(key, value));
      });
      _items = loadedMonsters;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addMonster(Monster m) async {
    try {
      final url = Uri.parse('${dbUrl}monsters.json');
      var response = await http.post(url, body: json.encode(Monster.toJson(m)));
      print(json.decode(response.body));
      String id = json.decode(response.body)['name'];
      print('ID: $id');
      m = m.copyWith(id: id);
      print('m.id: ${m.id}');
      _items.add(m);
      notifyListeners();
    } catch (err) {
      print(err.toString());
      throw HttpException('Error: Could not add monster');
    }
  }

  Future<void> updateMonster(int index, Monster m) async {
    final url = Uri.parse('${dbUrl}monsters/${m.id}.json');
    Monster beforeUpdate = _items[index];
    _items[index] = m;
    notifyListeners();
    try {
      var response =
          await http.patch(url, body: json.encode(Monster.toJson(m)));
      if (response.statusCode >= 400) {
        _items[index] = beforeUpdate;
        notifyListeners();
        throw HttpException('Error: Could not update monster');
      }
    } catch (err) {
      _items[index] = beforeUpdate;
      notifyListeners();
      print(err.toString());
      throw HttpException('Error: Could not update monster');
    }
  }

  Future<void> deleteMonster(String id) async {
    final url = Uri.parse('${dbUrl}monsters/$id.json');
    var _existingMonsterIndex =
        _items.indexWhere((monster) => monster.id == id);
    Monster? _existingMonster = _items[_existingMonsterIndex];
    _items.removeAt(_existingMonsterIndex);
    notifyListeners();
    await http.delete(url).then((response) {
      if (response.statusCode > 400) {
        _items.insert(_existingMonsterIndex, _existingMonster!);
        notifyListeners();
        throw new HttpException('Could not delete monster');
      } else {
        _existingMonster = null;
      }
    });
  }

  double getTotalBountyAmount() {
    var total = 0.0;
    getDefeatedMonsters.forEach((element) {
      total += element.bounty;
    });
    return total;
  }

  void changeDefeated(String id, bool defeatedValue) {
    var indexWhere = _items.indexWhere((element) => element.id == id);
    if (indexWhere != -1) {
      _items[indexWhere].isDefeated = defeatedValue;
      updateMonster(indexWhere, _items[indexWhere]);
    }
    notifyListeners();
  }
}
