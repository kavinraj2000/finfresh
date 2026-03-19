import 'package:equatable/equatable.dart';
import 'package:finfresh/src/common/utils/number_parser_util.dart';

class CategorySummaryModel extends Equatable {
  final String name;
  final double amount;

  const CategorySummaryModel({required this.name, required this.amount});

  factory CategorySummaryModel.fromJson(Map<String, dynamic> json) =>
      CategorySummaryModel(
        name: json['category']?.toString() ?? 'Other',
        amount: safeDouble(json['total']),
      );

  @override
  List<Object> get props => [name, amount];
}