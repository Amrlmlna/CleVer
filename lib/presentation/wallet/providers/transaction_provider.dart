import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../domain/entities/wallet_transaction.dart';
import '../../../core/config/api_config.dart';

class TransactionHistoryNotifier
    extends AsyncNotifier<List<WalletTransaction>> {
  @override
  Future<List<WalletTransaction>> build() async {
    return _fetchTransactions();
  }

  Future<List<WalletTransaction>> _fetchTransactions() async {
    try {
      final headers = await ApiConfig.getAuthHeaders();
      final uri = Uri.parse('${ApiConfig.baseUrl}/wallet/transactions');

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map(
              (json) =>
                  WalletTransaction.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      }

      throw Exception(
        'Failed to fetch transactions (Status: ${response.statusCode})',
      );
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchTransactions());
  }
}

final transactionHistoryProvider =
    AsyncNotifierProvider<TransactionHistoryNotifier, List<WalletTransaction>>(
      () => TransactionHistoryNotifier(),
    );
