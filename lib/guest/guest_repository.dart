import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:penalty_game/guest/models/guest.dart';

class GuestRepository {
  List<Guest>? _guests;
  List<String>? _companies;

  Future<void> load() async {
    if (_guests != null) return;
    final raw = await rootBundle.loadString('assets/guests.json');
    final list = jsonDecode(raw) as List<dynamic>;
    _guests = [
      for (final item in list)
        ...(TableGroup.fromJson(item as Map<String, dynamic>)).guests,
    ];
    _companies = _guests!.map((g) => g.company).toSet().toList()..sort();
  }

  List<String> get companies => _companies ?? [];

  List<String> searchCompanies(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return companies;
    return companies.where((c) => c.toLowerCase().contains(q)).toList();
  }

  List<String> namesForCompany(String company) {
    final names = _guests!
        .where((g) => g.company == company)
        .map((g) => g.name)
        .toSet()
        .toList()
      ..sort();
    return names;
  }

  int? tableFor(String company, String name) {
    final match = _guests!.where((g) => g.company == company && g.name == name);
    if (match.isEmpty) return null;
    return match.first.table;
  }
}
