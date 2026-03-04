import 'dart:convert';

class SavingsGoal {
  final String id;
  final String name;
  final String icon; // Material icon name
  final double targetAmount;
  final double currentAmount;
  final DateTime createdAt;

  SavingsGoal({
    required this.id,
    required this.name,
    this.icon = 'savings',
    required this.targetAmount,
    this.currentAmount = 0.0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  double get progress =>
      targetAmount > 0 ? (currentAmount / targetAmount).clamp(0.0, 1.0) : 0.0;

  double get remaining => (targetAmount - currentAmount).clamp(0.0, targetAmount);

  SavingsGoal copyWith({
    String? name,
    String? icon,
    double? targetAmount,
    double? currentAmount,
  }) {
    return SavingsGoal(
      id: id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory SavingsGoal.fromMap(Map<String, dynamic> map) {
    return SavingsGoal(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      icon: map['icon'] ?? 'savings',
      targetAmount: (map['targetAmount'] ?? 0).toDouble(),
      currentAmount: (map['currentAmount'] ?? 0).toDouble(),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory SavingsGoal.fromJson(String source) =>
      SavingsGoal.fromMap(json.decode(source));
}
