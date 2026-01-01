import 'dart:convert';

enum TransactionType { deposit, withdraw, transfer }

class TransactionModel {
  final String id;
  final TransactionType type;
  final double amount;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.index,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    // Handle API response format
    if (map.containsKey('transaction_type')) {
       TransactionType tType;
       final typeStr = map['transaction_type'];
       if (typeStr == 'DEPOSIT') {
         tType = TransactionType.deposit;
       } else if (typeStr == 'TRANSFER') {
         tType = TransactionType.transfer;
       } else {
         tType = TransactionType.withdraw; 
       }

       return TransactionModel(
        id: map['id'].toString(), // API returns int id
        type: tType,
        amount: double.tryParse(map['amount'].toString()) ?? 0.0,
        date: DateTime.parse(map['timestamp']),
      );
    }
    
    // Fallback for old local storage format (if any)
    return TransactionModel(
      id: map['id'] ?? '',
      type: TransactionType.values[map['type'] ?? 0],
      amount: map['amount']?.toDouble() ?? 0.0,
      date: DateTime.parse(map['date']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionModel.fromJson(String source) =>
      TransactionModel.fromMap(json.decode(source));
}
