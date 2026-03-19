import 'dart:convert';

import 'package:finfresh/src/common/consants/constants.dart';
import 'package:finfresh/src/domain/models/transaction_model.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class TransactionRepository {
  final log = Logger();

  Future<List<TransactionModel>> getTransactiondata({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await rootBundle.loadString(Constants.API.transaction);

      final Map<String, dynamic> data = jsonDecode(response);
      final List<dynamic> list = data['data'];

      final allTransactions = list
          .map((e) => TransactionModel.fromJson(e))
          .toList();

      final startIndex = (page - 1) * limit;
      final endIndex = startIndex + limit;

      if (startIndex >= allTransactions.length) {
        return [];
      }

      final paginatedList = allTransactions.sublist(
        startIndex,
        endIndex > allTransactions.length ? allTransactions.length : endIndex,
      );
      log.d('getTransactiondata::$paginatedList::$allTransactions');
      return paginatedList;
    } catch (e) {
      log.e(e);
      throw Exception('Failed to load Transaction data: $e');
    }
  }
}
