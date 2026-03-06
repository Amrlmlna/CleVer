import 'package:equatable/equatable.dart';

class WalletTransaction extends Equatable {
  final String id;
  final String type;
  final int amount;
  final String? source;
  final String? description;
  final DateTime timestamp;

  const WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    this.source,
    this.description,
    required this.timestamp,
  });

  bool get isAddition =>
      type == 'credit_add' || amount > 0 && type != 'credit_deduct';

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    DateTime parseTimestamp(dynamic ts) {
      if (ts == null) return DateTime.now();
      if (ts is String) return DateTime.tryParse(ts) ?? DateTime.now();
      if (ts is Map && ts['_seconds'] != null) {
        return DateTime.fromMillisecondsSinceEpoch(ts['_seconds'] * 1000);
      }
      return DateTime.now();
    }

    return WalletTransaction(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      amount: json['amount'] as int? ?? 0,
      source: json['source'] as String?,
      description: json['description'] as String?,
      timestamp: parseTimestamp(json['timestamp']),
    );
  }

  @override
  List<Object?> get props => [id, type, amount, source, description, timestamp];
}
