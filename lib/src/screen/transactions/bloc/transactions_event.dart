part of 'transactions_bloc.dart';

abstract class TransactionsEvent extends Equatable {
  const TransactionsEvent();
  @override
  List<Object> get props => [];
}

class LoadTransactions extends TransactionsEvent {
  const LoadTransactions();
}

class LoadMoreTransactions extends TransactionsEvent {
  const LoadMoreTransactions();
}

class RefreshTransactions extends TransactionsEvent {
  const RefreshTransactions();
}

class TransactionsScrolled extends TransactionsEvent {
  final double offset;
  final double maxScroll;

  const TransactionsScrolled({required this.offset, required this.maxScroll});
}
