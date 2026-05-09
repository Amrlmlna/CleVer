import 'package:equatable/equatable.dart';

class WalletTransaction extends Equatable {
  final String id;
  final String type;
  final int amount;
  final String? source;
  final String? description;
  final String? durationAdded;
  final String? productDisplayName;
  final DateTime timestamp;
  final DateTime? expiryDate;
  final String? status;

  const WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    this.source,
    this.description,
    this.durationAdded,
    this.productDisplayName,
    required this.timestamp,
    this.expiryDate,
    this.status,
  });

  bool get isAddition =>
      type == 'subscription_buy' ||
      type == 'subscription_update' ||
      (amount > 0 && type != 'cv_export');

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    DateTime parseTimestamp(dynamic ts) {
      if (ts == null) return DateTime.now();
      if (ts is String) return DateTime.tryParse(ts) ?? DateTime.now();
      if (ts is Map && ts['_seconds'] != null) {
        return DateTime.fromMillisecondsSinceEpoch(ts['_seconds'] * 1000);
      }
      return DateTime.now();
    }

    DateTime? parseOptionalTimestamp(dynamic ts) {
      if (ts == null) return null;
      if (ts is String) return DateTime.tryParse(ts);
      if (ts is Map && ts['_seconds'] != null) {
        return DateTime.fromMillisecondsSinceEpoch(ts['_seconds'] * 1000);
      }
      return null;
    }

    return WalletTransaction(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      amount: json['amount'] as int? ?? 0,
      source: json['source'] as String?,
      description: json['description'] as String?,
      durationAdded: json['durationAdded'] as String?,
      productDisplayName: json['productDisplayName'] as String?,
      timestamp: parseTimestamp(json['timestamp']),
      expiryDate: parseOptionalTimestamp(json['expiryDate']),
      status: json['status'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    type,
    amount,
    source,
    description,
    durationAdded,
    productDisplayName,
    timestamp,
    expiryDate,
    status,
  ];
}
