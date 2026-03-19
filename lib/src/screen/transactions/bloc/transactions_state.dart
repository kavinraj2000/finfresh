part of 'transactions_bloc.dart';

enum TransactionStatus { initial, loading, paginating, loaded, empty, error }

class TransactionsState extends Equatable {
  final TransactionStatus status;
  final String message;
  final List<TransactionModel> transactions;
  final bool hasMore;
  final int currentPage;

  const TransactionsState({
    required this.status,
    required this.message,
    required this.transactions,
    required this.hasMore,
    required this.currentPage,
  });

  factory TransactionsState.initial() {
    return const TransactionsState(
      status: TransactionStatus.initial,
      message: '',
      transactions: [],
      hasMore: true,
      currentPage: 1,
    );
  }

  TransactionsState copyWith({
    TransactionStatus? status,
    String? message,
    List<TransactionModel>? transactions,
    bool? hasMore,
    int? currentPage,
  }) {
    return TransactionsState(
      status: status ?? this.status,
      message: message ?? this.message,
      transactions: transactions ?? this.transactions,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        transactions,
        hasMore,
        currentPage,
      ];
}
