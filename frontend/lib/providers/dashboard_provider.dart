import 'package:flutter/material.dart';

import '../models/dashboard_stats.dart';
import '../services/dashboard_service.dart';

class DashboardProvider extends ChangeNotifier {
  final DashboardService _service =
      DashboardService();

  DashboardStats? stats;

  bool isLoading = false;

  Future<void> loadDashboard(
      String id) async {
    isLoading = true;

    notifyListeners();

    stats = await _service.getStats(id);

    isLoading = false;

    notifyListeners();
  }
}