import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:finfresh/src/domain/models/transaction_model.dart';
import 'package:finfresh/src/common/utils/formatter_util.dart';

class TransactionsGrid extends StatelessWidget {
  final List<TransactionModel> transactions;

  const TransactionsGrid({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;

        final dateW        = totalWidth * 0.15;
        final categoryW    = totalWidth * 0.18;
        final typeW        = totalWidth * 0.12;
        final descriptionW = totalWidth * 0.35;
        final amountW      = totalWidth * 0.20;

        return SizedBox(
          height: constraints.maxHeight,
          width: totalWidth,
          child: PlutoGrid(
            columns: _columns(dateW, categoryW, typeW, descriptionW, amountW),
            rows: _rows(),
            configuration: PlutoGridConfiguration(
              style: PlutoGridStyleConfig(
                rowHeight: 48,
                columnHeight: 50,
                gridBorderRadius: BorderRadius.circular(8),
                gridBorderColor: Colors.transparent,
              ),
              scrollbar: const PlutoGridScrollbarConfig(isAlwaysShown: false),
            ),
          ),
        );
      },
    );
  }

  List<PlutoColumn> _columns(
    double dateW,
    double categoryW,
    double typeW,
    double descriptionW,
    double amountW,
  ) {
    return [
      PlutoColumn(
        title: 'Date',
        field: 'date',
        type: PlutoColumnType.text(),
        enableSorting: true,
        width: dateW,
        minWidth: 90,
      ),
      PlutoColumn(
        title: 'Category',
        field: 'category',
        type: PlutoColumnType.text(),
        enableSorting: true,
        width: categoryW,
        minWidth: 100,
      ),
      PlutoColumn(
        title: 'Type',
        field: 'type',
        type: PlutoColumnType.text(),
        width: typeW,
        minWidth: 80,
        renderer: (rendererContext) {
          final type = rendererContext.cell.value.toString();
          final isIncome = type.toLowerCase() == 'income';
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: (isIncome ? Colors.green : Colors.red).withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              type.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: isIncome ? Colors.green : Colors.red,
                letterSpacing: 0.5,
              ),
            ),
          );
        },
      ),
      PlutoColumn(
        title: 'Description',
        field: 'description',
        type: PlutoColumnType.text(),
        width: descriptionW,
        minWidth: 150,
        renderer: (rendererContext) {
          return Text(
            rendererContext.cell.value.toString(),
            overflow: TextOverflow.ellipsis,
          );
        },
      ),
      PlutoColumn(
        title: 'Amount',
        field: 'amount',
        type: PlutoColumnType.number(),
        enableSorting: true,
        width: amountW,
        minWidth: 100,
        textAlign: PlutoColumnTextAlign.right,
        titleTextAlign: PlutoColumnTextAlign.right,
        renderer: (rendererContext) {
          final type = rendererContext.row.cells['type']?.value ?? '';
          final value = rendererContext.cell.value ?? 0;
          final isIncome = type.toString().toLowerCase() == 'income';

          return Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${isIncome ? '+' : '-'}${formatCurrency(value)}',
              style: TextStyle(
                color: isIncome ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    ];
  }

  List<PlutoRow> _rows() {
    return transactions.map((txn) {
      return PlutoRow(
        cells: {
          'date':        PlutoCell(value: formatDate(txn.date)),
          'category':    PlutoCell(value: txn.category),
          'type':        PlutoCell(value: txn.type),
          'description': PlutoCell(value: txn.description ?? txn.category),
          'amount':      PlutoCell(value: txn.amount),
        },
      );
    }).toList();
  }
}