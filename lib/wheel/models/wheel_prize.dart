class WheelPrize {
  const WheelPrize({
    required this.id,
    required this.image,
    required this.title,
    required this.probability,
    required this.maxDaily,
    required this.maxTotal,
  });

  final String id;
  final String image;
  final String title;
  final double probability;
  final int maxDaily;
  final int maxTotal;

  factory WheelPrize.fromJson(Map<String, dynamic> json) {
    return WheelPrize(
      id: json['id'] as String,
      image: json['image'] as String,
      title: json['title'] as String,
      probability: (json['probability'] as num).toDouble(),
      maxDaily: json['maxDaily'] as int,
      maxTotal: json['maxTotal'] as int,
    );
  }
}

class WheelConfig {
  const WheelConfig({
    required this.spinDurationMs,
    required this.minRotations,
    required this.prizes,
  });

  final int spinDurationMs;
  final int minRotations;
  final List<WheelPrize> prizes;

  factory WheelConfig.fromJson(Map<String, dynamic> json) {
    final prizesJson = json['prizes'] as List<dynamic>;
    return WheelConfig(
      spinDurationMs: json['spinDurationMs'] as int? ?? 4200,
      minRotations: json['minRotations'] as int? ?? 4,
      prizes: prizesJson
          .map((e) => WheelPrize.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
