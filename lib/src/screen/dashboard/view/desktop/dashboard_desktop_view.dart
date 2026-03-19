import 'package:finfresh/app/route_name.dart';
import 'package:finfresh/src/common/consants/constants.dart';
import 'package:finfresh/src/common/utils/formatter_util.dart';
import 'package:finfresh/src/common/widgets/category_breakdown.dart';
import 'package:finfresh/src/common/widgets/empty_state.dart';
import 'package:finfresh/src/common/widgets/error_state.dart';
import 'package:finfresh/src/common/widgets/health_score_card.dart';
import 'package:finfresh/src/common/widgets/loading_state.dart';
import 'package:finfresh/src/common/widgets/summary_card.dart';
import 'package:finfresh/src/screen/dashboard/bloc/dashboard_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DashboardDesktopview extends StatelessWidget {
  const DashboardDesktopview({super.key});



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        toolbarHeight: 60,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.account_balance_wallet_rounded,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              Constants.APP.app,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.primary,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        actions: [
          if (width >= 600)
            TextButton.icon(
              onPressed: () => context.go(RouteName.transaction),
              icon: const Icon(Icons.receipt_long_rounded, size: 18),
              label: const Text('Transactions'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.receipt_long_rounded),
              onPressed: () => context.go(RouteName.transaction),
              tooltip: 'Transactions',
            ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {},
            tooltip: 'Logout',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state.status == DashboardStatus.loading ||
              state.status == DashboardStatus.initial) {
            return const LoadingState(message: 'Loading your dashboard...');
          }

          if (state.status == DashboardStatus.error) {
            return ErrorState(
              message: state.message,
              onRetry: () =>
                  context.read<DashboardBloc>().add(const RefreshDashboard()),
            );
          }

          if (state.status == DashboardStatus.empty) {
            return EmptyState(
              message: 'No transactions found for this month',
              subtitle:
                  'Start adding transactions to see your financial overview.',
              onAction: () =>
                  context.read<DashboardBloc>().add(const RefreshDashboard()),
              actionLabel: 'Refresh',
            );
          }

          if (state.status == DashboardStatus.loaded) {
            return _DashboardContent(state: state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final DashboardState state;

  const _DashboardContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final isDesktop = width >= 1200;
    final isTablet = width >= 900 && width < 1200;

    const double maxContentWidth = 1400;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<DashboardBloc>().add(const RefreshDashboard());
      },
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxContentWidth),
          child: isDesktop
              ? _DesktopLayout(state: state)
              : _MobileTabletLayout(state: state, isTablet: isTablet),
        ),
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  final DashboardState state;
  const _DesktopLayout({required this.state});

  @override
  Widget build(BuildContext context) {
    final summary = state.summary!;
    final health = state.healthScore!;

    return ListView(
      padding: const EdgeInsets.fromLTRB(32, 28, 32, 32),
      children: [
        _PageHeader(
          title: 'Dashboard Overview',
          subtitle: 'Your financial summary for this month',
        ),

        const SizedBox(height: 24),

        _SummaryGrid(summary: summary, crossAxisCount: 4),

        const SizedBox(height: 24),

        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: summary.categories.isNotEmpty
                    ? CategoryBreakdown(
                        categories: summary.categories,
                        totalExpenses: summary.monthlyExpenses,
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(width: 24),
              Expanded(flex: 2, child: HealthScoreCard(healthScore: health)),
            ],
          ),
        ),
      ],
    );
  }
}

class _MobileTabletLayout extends StatelessWidget {
  final DashboardState state;
  final bool isTablet;
  const _MobileTabletLayout({required this.state, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final summary = state.summary!;
    final health = state.healthScore!;

    return ListView(
      padding: EdgeInsets.all(isTablet ? 24 : 16),
      children: [
        _PageHeader(
          title: 'Overview',
          subtitle: 'Your financial summary for this month',
        ),

        const SizedBox(height: 16),

        _SummaryGrid(summary: summary, crossAxisCount: isTablet ? 4 : 2),

        const SizedBox(height: 16),

        HealthScoreCard(healthScore: health),

        const SizedBox(height: 16),

        if (summary.categories.isNotEmpty)
          CategoryBreakdown(
            categories: summary.categories,
            totalExpenses: summary.monthlyExpenses,
          ),

        const SizedBox(height: 16),
      ],
    );
  }
}

class _PageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const _PageHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  final dynamic summary;
  final int crossAxisCount;

  const _SummaryGrid({required this.summary, required this.crossAxisCount});

  @override
  Widget build(BuildContext context) {
    final cards = [
      SummaryCard(
        title: 'Monthly Income',
        value: formatCurrency(summary.monthlyIncome),
        icon: Icons.arrow_downward_rounded,
        color: const Color(0xFF1D9E75),
        subtitle: 'This month',
      ),
      SummaryCard(
        title: 'Monthly Expenses',
        value: formatCurrency(summary.monthlyExpenses),
        icon: Icons.arrow_upward_rounded,
        color: const Color(0xFFE24B4A),
        subtitle: 'This month',
      ),
      SummaryCard(
        title: 'Savings',
        value: formatCurrency(summary.savings),
        icon: Icons.savings_rounded,
        color: const Color(0xFF378ADD),
        subtitle: 'Net saved',
      ),
      SummaryCard(
        title: 'Savings Rate',
        value: formatPercent(summary.savingsRate),
        icon: Icons.percent_rounded,
        color: const Color(0xFF7F77DD),
        subtitle: 'Of income',
      ),
    ];

    if (crossAxisCount == 4) {
      return Row(
        children:
            cards
                .map(
                  (card) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: SizedBox(height: 110, child: card),
                    ),
                  ),
                )
                .toList()
              ..last = Expanded(
                child: SizedBox(height: 110, child: cards.last),
              ),
      );
    }

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: cards,
    );
  }
}
