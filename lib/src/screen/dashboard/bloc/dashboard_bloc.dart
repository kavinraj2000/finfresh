import 'package:equatable/equatable.dart';
import 'package:finfresh/src/domain/models/health_score_model.dart';
import 'package:finfresh/src/domain/models/summary_model.dart';
import 'package:finfresh/src/screen/dashboard/repo/dashboard_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository repo;

  DashboardBloc({required this.repo}) : super(DashboardState.initial()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<RefreshDashboard>(_onLoadDashboard);
  }

  Future<void> _onLoadDashboard(
    DashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading));
    try {
      final results = await Future.wait([
        repo.getSummarydata(),
        repo.getFinancialHealth(),
      ]);

      final summary = results[0] as dynamic;
      final healthScore = results[1] as dynamic;

      if (summary.categories.isEmpty && summary.monthlyIncome == 0.0) {
        emit(state.copyWith(status: DashboardStatus.empty));
      } else {
        emit(
          state.copyWith(
            status: DashboardStatus.loaded,
            summary: summary,
            healthScore: healthScore,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(status: DashboardStatus.error, message: e.toString()),
      );
    }
  }
}
