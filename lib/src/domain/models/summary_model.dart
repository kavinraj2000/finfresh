import 'package:equatable/equatable.dart';
import 'package:finfresh/src/common/utils/number_parser_util.dart';
import 'package:finfresh/src/domain/models/category_summary_model.dart';

class SummaryModel extends Equatable {
  final double monthlyIncome;
  final double monthlyExpenses;
  final double savings;
  final double savingsRate;
  final List<CategorySummaryModel> categories;

  const SummaryModel({
    required this.monthlyIncome,
    required this.monthlyExpenses,
    required this.savings,
    required this.savingsRate,
    required this.categories,
  });

  factory SummaryModel.fromJson(Map<String, dynamic> json) {
    final income = safeDouble(json['monthly_income']);
    final expenses = safeDouble(json['monthly_expenses']);
    final savings = safeDouble(json['savings']);
    final savingsRate = income > 0 ? (savings / income) * 100 : 0.0;

    final rawCategories = json['categories'];
    final categories = rawCategories is List
        ? rawCategories
              .whereType<Map<String, dynamic>>()
              .map(CategorySummaryModel.fromJson)
              .toList()
        : <CategorySummaryModel>[];

    return SummaryModel(
      monthlyIncome: income,
      monthlyExpenses: expenses,
      savings: savings,
      savingsRate: savingsRate,
      categories: categories,
    );
  }

  @override
  List<Object> get props => [
    monthlyIncome,
    monthlyExpenses,
    savings,
    savingsRate,
    categories,
  ];
}
