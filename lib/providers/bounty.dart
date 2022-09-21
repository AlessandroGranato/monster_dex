import 'package:flutter/foundation.dart';

import 'monster.dart';

class Bounty with ChangeNotifier {
  final String id;
  final List<Monster> monsters;
  final DateTime dateTime;
  final double bountyValue;

  Bounty(this.id, this.monsters, this.dateTime, this.bountyValue);

  Bounty copyWith({
    String? id,
    List<Monster>? monsters,
    DateTime? dateTime,
    double? bountyValue,
  }) =>
      Bounty(
        id ?? this.id,
        monsters ?? this.monsters,
        dateTime ?? this.dateTime,
        bountyValue ?? this.bountyValue,
      );

  static Map<String, dynamic> toJson(Bounty b) {
    return ({
      'id': b.id,
      'dateTime': b.dateTime.toIso8601String(),
      'bountyValue': b.bountyValue,
      'monsters': b.monsters.map((e) => Monster.toJson(e)).toList(),
    });
  }

  Bounty.fromJson(String key, Map<String, dynamic> json)
      : id = key,
        dateTime = DateTime.parse(json['dateTime']),
        bountyValue = json['bountyValue'],
        monsters = (json['monsters'] as List<dynamic>)
            .map((e) => Monster.fromJsonMap(e))
            .toList();
}
