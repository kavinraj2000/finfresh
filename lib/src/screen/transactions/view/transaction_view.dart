import 'package:finfresh/src/screen/transactions/bloc/transactions_bloc.dart';
import 'package:finfresh/src/screen/transactions/repo/transaction_repository.dart';
import 'package:finfresh/src/screen/transactions/view/desktop/transaction_desktop_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class TransactionView extends StatelessWidget {
  const TransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          TransactionsBloc(repo: TransactionRepository())
            ..add(const LoadTransactions()),
      child: ResponsiveValue<Widget>(
        context,
        defaultValue: TransactionsScreen(),
        conditionalValues: const [
          Condition.smallerThan(name: MOBILE, value: TransactionsScreen()),
        ],
      ).value,
    );
  }
}
