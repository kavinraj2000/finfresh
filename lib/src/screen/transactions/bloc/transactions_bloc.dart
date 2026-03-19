import 'package:equatable/equatable.dart';
import 'package:finfresh/src/domain/models/transaction_model.dart';
import 'package:finfresh/src/screen/transactions/repo/transaction_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'transactions_event.dart';
part 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  final TransactionRepository repo;
  static const int _limit = 20;

  TransactionsBloc({required this.repo}) : super(TransactionsState.initial()) {
    on<LoadTransactions>(_onLoad);
    on<RefreshTransactions>(_onRefresh);
    on<LoadMoreTransactions>(_onLoadMore);
    on<TransactionsScrolled>(_onScrolled);
  }

  Future<void> _onLoad(
    LoadTransactions event,
    Emitter<TransactionsState> emit,
  ) async {
    emit(state.copyWith(status: TransactionStatus.loading));

    try {
      final items = await repo.getTransactiondata(page: 1, limit: _limit);

      if (items.isEmpty) {
        emit(state.copyWith(status: TransactionStatus.empty));
      } else {
        emit(
          state.copyWith(
            status: TransactionStatus.loaded,
            transactions: items,
            currentPage: 1,
            hasMore: items.length == _limit,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(status: TransactionStatus.error, message: e.toString()),
      );
    }
  }

  Future<void> _onRefresh(
    RefreshTransactions event,
    Emitter<TransactionsState> emit,
  ) async {
    add(const LoadTransactions());
  }

  Future<void> _onLoadMore(
    LoadMoreTransactions event,
    Emitter<TransactionsState> emit,
  ) async {
    if (!state.hasMore || state.status == TransactionStatus.paginating) return;

    emit(state.copyWith(status: TransactionStatus.paginating));

    try {
      final nextPage = state.currentPage + 1;

      final newItems = await repo.getTransactiondata(
        page: nextPage,
        limit: _limit,
      );

      final updatedList = [...state.transactions, ...newItems];

      emit(
        state.copyWith(
          status: TransactionStatus.loaded,
          transactions: updatedList,
          currentPage: nextPage,
          hasMore: newItems.length == _limit,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: TransactionStatus.error, message: e.toString()),
      );
    }
  }

  Future<void> _onScrolled(
    TransactionsScrolled event,
    Emitter<TransactionsState> emit,
  ) async {
    final threshold = 200;

    final isBottom = event.offset >= event.maxScroll - threshold;

    if (!isBottom || !state.hasMore) return;

    if (state.status == TransactionStatus.paginating) return;

    add(const LoadMoreTransactions());
  }
}
