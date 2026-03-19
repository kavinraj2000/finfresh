import 'package:equatable/equatable.dart';
import 'package:finfresh/src/common/utils/number_parser_util.dart';

class TransactionModel extends Equatable {
  final String id;
  final DateTime date;
  final String type;
  final String category;
  final double amount;
  final String? description;

  const TransactionModel({
    required this.id,
    required this.date,
    required this.type,
    required this.category,
    required this.amount,
    this.description,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json['id']?.toString() ?? '',
        date: _parseDate(json['date']),
        type: json['type']?.toString() ?? 'unknown',
        category: json['category']?.toString() ?? 'Other',
        amount: safeDouble(json['amount']),
        description: json['description']?.toString(),
      );

  static DateTime _parseDate(dynamic raw) {
    if (raw == null) return DateTime.now();
    try {
      return DateTime.parse(raw.toString());
    } catch (_) {
      return DateTime.now();
    }
  }

  @override
  List<Object?> get props => [id, date, type, category, amount, description];
}
