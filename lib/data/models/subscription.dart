class Subscription {
  final int id;
  final String type;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;

  Subscription({
    required this.id,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.isActive,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: (json['id'] ?? 0) as int,
      type: (json['type'] ?? '') as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      isActive: (json['is_active'] ?? false) as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'is_active': isActive,
    };
  }

  bool get isValid => isActive && endDate.isAfter(DateTime.now());
}

