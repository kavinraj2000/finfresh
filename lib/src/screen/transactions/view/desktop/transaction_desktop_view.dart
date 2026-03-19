import 'package:finfresh/src/common/consants/constants.dart';
import 'package:finfresh/src/common/widgets/app_bar_widget.dart';
import 'package:finfresh/src/common/widgets/empty_state.dart';
import 'package:finfresh/src/common/widgets/error_state.dart';
import 'package:finfresh/src/common/widgets/loading_state.dart';
import 'package:finfresh/src/common/widgets/transaction_list_item.dart';
import 'package:finfresh/src/screen/transactions/bloc/transactions_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: CommonAppBar(title: Constants.APP.app),
      body: BlocBuilder<TransactionsBloc, TransactionsState>(
        builder: (context, state) {
          if (state.status == TransactionStatus.loading) {
            return const LoadingState(message: 'Loading...');
          }

          if (state.status == TransactionStatus.error) {
            return ErrorState(message: state.message);
          }

          if (state.status == TransactionStatus.empty) {
            return const EmptyState(message: 'No transactions');
          }

          final items = state.transactions;
          final isPaginating = state.status == TransactionStatus.paginating;

          if (isMobile) {
            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollUpdateNotification) {
                  context.read<TransactionsBloc>().add(
                    TransactionsScrolled(
                      offset: notification.metrics.pixels,
                      maxScroll: notification.metrics.maxScrollExtent,
                    ),
                  );
                }
                return false;
              },
              child: ListView.builder(
                itemCount: items.length + (isPaginating ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == items.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return TransactionsGrid(transactions: items);
                },
              ),
            );
          }

          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: TransactionsGrid(transactions: items),
          );
        },
      ),
    );
  }
}
