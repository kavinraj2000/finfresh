import 'package:fl_chart/fl_chart.dart';
import 'package:finfresh/src/common/helper/category_color_helper.dart';
import 'package:finfresh/src/common/utils/formatter_util.dart';
import 'package:flutter/material.dart';
import '../../domain/models/category_summary_model.dart';

class CategoryBreakdown extends StatefulWidget {
  final List<CategorySummaryModel> categories;
  final double totalExpenses;

  const CategoryBreakdown({
    super.key,
    required this.categories,
    required this.totalExpenses,
  });

  @override
  State<CategoryBreakdown> createState() => _CategoryBreakdownState();
}

class _CategoryBreakdownState extends State<CategoryBreakdown> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sorted = [...widget.categories]
      ..sort((a, b) => b.amount.compareTo(a.amount));

    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return Card(
      elevation: 0,
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'Category Breakdown',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  'Total: ${formatCurrency(widget.totalExpenses)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: _buildPieChart(sorted),
                  ),
                  const SizedBox(width: 28),
                  Expanded(child: _buildLegendList(sorted, theme)),
                ],
              )
            else
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 220, child: _buildPieChart(sorted)),
                  const SizedBox(height: 20),
                  _buildLegendList(sorted, theme),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(List<CategorySummaryModel> sorted) {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                _touchedIndex = -1;
                return;
              }
              _touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
        borderData: FlBorderData(show: false),
        sectionsSpace: 2,
        centerSpaceRadius: 50,
        sections: sorted.asMap().entries.map((entry) {
          final index = entry.key;
          final category = entry.value;
          final isTouched = index == _touchedIndex;
          final percent = widget.totalExpenses > 0
              ? (category.amount / widget.totalExpenses * 100)
              : 0.0;
          final color = CategoryColorHelper.getColor(index);

          return PieChartSectionData(
            color: color,
            value: category.amount,
            title: isTouched ? '${percent.toStringAsFixed(1)}%' : '',
            radius: isTouched ? 55 : 45,
            titleStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLegendList(List<CategorySummaryModel> sorted, ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: sorted.asMap().entries.map((entry) {
        final index = entry.key;
        final category = entry.value;
        final color = CategoryColorHelper.getColor(index);
        final percent = widget.totalExpenses > 0
            ? (category.amount / widget.totalExpenses * 100)
            : 0.0;

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 10),

              Expanded(
                flex: 3,
                child: Text(
                  category.name,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),

              Expanded(
                flex: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (percent / 100).clamp(0.0, 1.0),
                    minHeight: 6,
                    backgroundColor: color.withOpacity(0.15),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              SizedBox(
                width: 40,
                child: Text(
                  '${percent.toStringAsFixed(1)}%',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(width: 10),

              SizedBox(
                width: 72,
                child: Text(
                  formatCurrency(category.amount),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
