import 'dart:convert';
import 'package:finfresh/src/common/consants/constants.dart';
import 'package:finfresh/src/domain/models/health_score_model.dart';
import 'package:finfresh/src/domain/models/summary_model.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class DashboardRepository {
  final log = Logger();

  Future<SummaryModel> getSummarydata() async {
    try {
      final String response = await rootBundle.loadString(
        Constants.API.summary,
      );
      final Map<String, dynamic> data = jsonDecode(response);
      log.d('getSummarydata::response:::$data');
      return SummaryModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to load summary data :$e');
    }
  }

  Future<FinancialHealthScoreModel> getFinancialHealth() async {
    try {
      final String response = await rootBundle.loadString(
        Constants.API.financialHealth,
      );
      final Map<String, dynamic> data = jsonDecode(response);

      return FinancialHealthScoreModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to load FinancialHealth data :$e');
    }
  }
}
