part of 'dashboard_bloc.dart';

enum DashboardStatus { initial, loading, loaded, empty, error }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final String message;
  final SummaryModel? summary;
  final FinancialHealthScoreModel? healthScore;

  const DashboardState({
    required this.status,
    required this.message,
    this.summary,
    this.healthScore,
  });

  factory DashboardState.initial() {
    return const DashboardState(
      status: DashboardStatus.initial,
      healthScore: null,
      message: '',
      summary: null,
    );
  }

  DashboardState copyWith({
    DashboardStatus? status,
    String? message,
    SummaryModel? summary,
    FinancialHealthScoreModel? healthScore,
  }) {
    return DashboardState(
      status: status ?? this.status,
      message: message ?? this.message,
      summary: summary ?? this.summary,
      healthScore: healthScore ?? this.healthScore,
    );
  }

  @override
  List<Object?> get props => [status, message, summary, healthScore];
}
