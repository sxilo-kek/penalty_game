import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:penalty_game/wheel/models/wheel_prize.dart';

class WheelConfigLoader {
  static Future<WheelConfig> load() async {
    final raw = await rootBundle.loadString('assets/wheel_prizes.json');
    return WheelConfig.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}
