import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:monster_dex/utils/constants.dart';
import 'package:monster_dex/providers/bounty.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class Bounties with ChangeNotifier {

  String? dbUrl = dotenv.env['DB_URL'];

  List<Bounty> _items = [];

  List<Bounty> get getBounties {
    return [..._items];
  }

  Bounty findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addBounty(Bounty b) async {
    final url = Uri.parse('${dbUrl}bounties.json');
    var response = await http.post(url, body: json.encode(Bounty.toJson(b)));
    b = b.copyWith(id: json.decode(response.body)['name']);
    _items.add(b);
    notifyListeners();
  }

    Future<void> fetchBounties() async {
    final url = Uri.parse('${dbUrl}bounties.json');
    var response = await http.get(url);
    List<Bounty> loadedBounties = [];
    var fetchedData = json.decode(response.body) as Map<String, dynamic>;
    if(fetchedData == null) {
      return;
    }
    fetchedData.forEach((key, value) {
      loadedBounties.add(Bounty.fromJson(key, value));
    });
    _items = loadedBounties.reversed.toList();
    notifyListeners();
  }

  int itemCount() {
    return _items.length;
  }
}