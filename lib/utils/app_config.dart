import 'dart:convert';
import 'package:flutter/services.dart';

class AppConfig {
  final String dbUrl;

  AppConfig({required this.dbUrl});

  static Future<AppConfig> loadProperties() async {

    // load the json file
    final contents = await rootBundle.loadString(
      'assets/config/config.json',
    );

    // decode our json
    final json = jsonDecode(contents);

    // convert our JSON into an instance of our AppConfig class
    return AppConfig(dbUrl: json['dbUrl']);
  }
}