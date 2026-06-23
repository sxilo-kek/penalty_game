class Guest {
  const Guest({
    required this.name,
    required this.company,
    required this.table,
  });

  final String name;
  final String company;
  final int table;

  factory Guest.fromJson(Map<String, dynamic> json, int table) {
    return Guest(
      name: json['name'] as String,
      company: json['company'] as String,
      table: table,
    );
  }
}

class TableGroup {
  const TableGroup({required this.table, required this.guests});

  final int table;
  final List<Guest> guests;

  factory TableGroup.fromJson(Map<String, dynamic> json) {
    final table = json['table'] as int;
    final guestsJson = json['guests'] as List<dynamic>;
    return TableGroup(
      table: table,
      guests: guestsJson
          .map((e) => Guest.fromJson(e as Map<String, dynamic>, table))
          .toList(),
    );
  }
}
