import 'package:intl/intl.dart';

final _currencyFormatter = NumberFormat.currency(
  locale: 'en_IN',
  symbol: '₹',
  decimalDigits: 0,
);

final _dateFormatter = DateFormat('dd MMM yyyy');

String formatCurrency(double amount) => _currencyFormatter.format(amount);

String formatPercent(double value) => '${value.toStringAsFixed(0)}%';

String formatDate(DateTime date) => _dateFormatter.format(date);
