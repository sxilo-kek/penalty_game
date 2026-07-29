import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:penalty_game/school/models/school.dart';

class SchoolRepository {
  List<School>? _schools;

  Future<List<School>> load() async {
    if (_schools != null) return _schools!;
    final raw = await rootBundle.loadString('assets/schools.json');
    final list = jsonDecode(raw) as List<dynamic>;
    _schools = list
        .map((item) => School.fromJson(item as Map<String, dynamic>))
        .toList();
    return _schools!;
  }
}
