import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:monster_dex/utils/constants.dart';
import 'package:monster_dex/utils/exceptions/http_exception.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Monster with ChangeNotifier {
  final String id;
  final String name;
  List<String> strengths;
  List<String> weaknesses;
  final String notes;
  String imageUrl;
  bool isDefeated;
  final double bounty;

  Monster({
    required this.id,
    required this.name,
    required this.strengths,
    required this.weaknesses,
    required this.notes,
    required this.imageUrl,
    required this.isDefeated,
    required this.bounty,
  });

  Monster.onlyIdAndName({
    required this.id,
    required this.name,
    List<String>? strengths,
    List<String>? weaknesses,
    this.notes = '',
    this.imageUrl = '',
    this.isDefeated = false,
    this.bounty = 0.0,
  })  : strengths = strengths ?? [],
        weaknesses = weaknesses ?? [];

  Monster.noArgs({
    String? id,
    String? name,
    List<String>? strengths,
    List<String>? weaknesses,
    String? notes,
    String? imageUrl,
    bool? isDefeated,
    double? bounty,
  })  : id = id ?? DateTime.now().toString(),
        name = name ?? '',
        strengths = strengths ?? [],
        weaknesses = weaknesses ?? [],
        notes = notes ?? '',
        imageUrl = imageUrl ?? '',
        isDefeated = isDefeated ?? false,
        bounty = bounty ?? 0.0;

  Monster copyWith({
    String? id,
    String? name,
    List<String>? strengths,
    List<String>? weaknesses,
    String? notes,
    String? imageUrl,
    bool? isDefeated,
    double? bounty,
  }) =>
      Monster(
        id: id ?? this.id,
        name: name ?? this.name,
        strengths: strengths ?? this.strengths,
        weaknesses: weaknesses ?? this.weaknesses,
        notes: notes ?? this.notes,
        imageUrl: imageUrl ?? this.imageUrl,
        isDefeated: isDefeated ?? this.isDefeated,
        bounty: bounty ?? this.bounty,
      );

  static Map<String, dynamic> toJson(Monster m) {
    return ({
      'id': m.id,
      'name': m.name,
      //'strengths': m.strengths,
      //'weaknesses': m.weaknesses,
      'notes': m.notes,
      'imageUrl': m.imageUrl,
      'isDefeated': m.isDefeated,
      'bounty': m.bounty,
    });
  }

  Monster.fromJsonKeyMap(String key, Map<String, dynamic> json)
      : id = key,
        name = json['name'] ?? '',
        strengths = json['strengths'] ?? [],
        weaknesses = json['weaknesses'] ?? [],
        notes = json['notes'] ?? '',
        imageUrl = json['imageUrl'] ?? '',
        isDefeated = json['isDefeated'] ?? false,
        bounty = json['bounty'] ?? 0.0;

    Monster.fromJsonMap(Map<String, dynamic> json)
      : id = json['id'] ?? '',
        name = json['name'] ?? '',
        strengths = json['strengths'] ?? [],
        weaknesses = json['weaknesses'] ?? [],
        notes = json['notes'] ?? '',
        imageUrl = json['imageUrl'] ?? '',
        isDefeated = json['isDefeated'] ?? false,
        bounty = json['bounty'] ?? 0.0;      

  Future<void> toggleDefeated() async {
    String? dbUrl = dotenv.env['DB_URL'];
    final url = Uri.parse('${dbUrl}monsters/${id}.json');
    var oldIsDefeated = isDefeated;
    isDefeated = !isDefeated;
    notifyListeners();
    try {
      var response =
          await http.patch(url, body: json.encode(Monster.toJson(this)));
      print(response.statusCode);
      if(response.statusCode >= 400) {
        isDefeated = oldIsDefeated;
        notifyListeners();
        throw new HttpException('Could not update isDefeated');
      }
    } catch (error) {
      print(error);
      isDefeated = oldIsDefeated;
      notifyListeners();
      throw new HttpException('Could not update isDefeated');
    }
  }
}
