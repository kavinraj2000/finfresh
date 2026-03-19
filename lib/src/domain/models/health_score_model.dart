import 'package:equatable/equatable.dart';
import 'package:finfresh/src/common/utils/number_parser_util.dart';

enum FinancialHealthCategory { excellent, healthy, moderate, atRisk }

class FinancialHealthScoreModel extends Equatable {
  final double score;
  final FinancialHealthCategory category;
  final List<String> suggestions;

  const FinancialHealthScoreModel({
    required this.score,
    required this.category,
    required this.suggestions,
  });

  factory FinancialHealthScoreModel.fromJson(Map<String, dynamic> json) {
    final score = safeDouble(json['score']);
    final raw = json['category']?.toString().toLowerCase() ?? '';
    final category = switch (raw) {
      'excellent' => FinancialHealthCategory.excellent,
      'healthy' => FinancialHealthCategory.healthy,
      'moderate' => FinancialHealthCategory.moderate,
      _ => FinancialHealthCategory.atRisk,
    };

    final rawSuggestions = json['suggestions'];
    final suggestions = rawSuggestions is List
        ? rawSuggestions.map((e) => e.toString()).toList()
        : <String>[];

    return FinancialHealthScoreModel(
      score: score,
      category: category,
      suggestions: suggestions,
    );
  }

  String get categoryLabel => switch (category) {
    FinancialHealthCategory.excellent => 'Excellent',
    FinancialHealthCategory.healthy => 'Healthy',
    FinancialHealthCategory.moderate => 'Moderate',
    FinancialHealthCategory.atRisk => 'At Risk',
  };

  @override
  List<Object> get props => [score, category, suggestions];
}
