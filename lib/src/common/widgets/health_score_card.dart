import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:finfresh/src/domain/models/health_score_model.dart';

class HealthScoreCard extends StatelessWidget {
  final FinancialHealthScoreModel healthScore;

  const HealthScoreCard({super.key, required this.healthScore});

  List<Map<String, dynamic>> _gaugeSections(double score) {
    return [
      {
        "label": "At Risk",
        "range": "0–40",
        "color": const Color(0xFFE24B4A),
        "active": score < 40,
      },
      {
        "label": "Moderate",
        "range": "40–70",
        "color": const Color(0xFFE8A128),
        "active": score >= 40 && score < 70,
      },
      {
        "label": "Healthy",
        "range": "70–85",
        "color": const Color(0xFF639922),
        "active": score >= 70 && score < 85,
      },
      {
        "label": "Excellent",
        "range": "85+",
        "color": const Color(0xFF1D9E75),
        "active": score >= 85,
      },
    ];
  }

  Widget _buildBarChart(double score, Color color) {
    final bars = List.generate(5, (i) {
      final threshold = (i + 1) * 20.0;
      final fill = (score >= threshold)
          ? 1.0
          : (score > i * 20)
          ? ((score - i * 20) / 20).clamp(0.0, 1.0)
          : 0.0;
      return fill;
    });

    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        maxY: 1.0,
        barGroups: bars.asMap().entries.map((e) {
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: e.value > 0 ? e.value : 0.08,
                color: e.value > 0
                    ? color.withOpacity(0.3 + 0.7 * e.value)
                    : color.withOpacity(0.1),
                width: 18,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGaugePill(Map<String, dynamic> section, ThemeData theme) {
    final bool active = section["active"];
    final Color color = section["color"];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
      decoration: BoxDecoration(
        color: active
            ? color.withOpacity(0.15)
            : theme.colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: active ? color.withOpacity(0.4) : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 3,
            decoration: BoxDecoration(
              color: active ? color : theme.colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            section["label"],
            style: theme.textTheme.labelSmall?.copyWith(
              color: active
                  ? color
                  : theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
              fontWeight: active ? FontWeight.w700 : FontWeight.w400,
              fontSize: 10,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _categoryColor();
    final score = healthScore.score;
    final sections = _gaugeSections(score);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Financial Health',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    healthScore.categoryLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          score.toInt().toString(),
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: color,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text('/100'),
                      ],
                    ),
                    Text(
                      healthScore.categoryLabel,
                      style: TextStyle(color: color),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: SizedBox(
                    height: 64,
                    child: _buildBarChart(score, color),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            LinearProgressIndicator(
              value: score / 100,
              minHeight: 10,
              backgroundColor: color.withOpacity(0.12),
              valueColor: AlwaysStoppedAnimation(color),
            ),

            const SizedBox(height: 16),

            Row(
              children: sections.map((s) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: _buildGaugePill(s, theme),
                  ),
                );
              }).toList(),
            ),

            if (healthScore.suggestions.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text("Suggestions"),
              const SizedBox(height: 10),
              ...healthScore.suggestions.map(
                (s) => Row(
                  children: [
                    Icon(Icons.lightbulb, color: color, size: 16),
                    const SizedBox(width: 8),
                    Expanded(child: Text(s)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _categoryColor() {
    switch (healthScore.category) {
      case FinancialHealthCategory.excellent:
        return const Color(0xFF1D9E75);
      case FinancialHealthCategory.healthy:
        return const Color(0xFF639922);
      case FinancialHealthCategory.moderate:
        return const Color(0xFFE8A128);
      case FinancialHealthCategory.atRisk:
        return const Color(0xFFE24B4A);
    }
  }
}
