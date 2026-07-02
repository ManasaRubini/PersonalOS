import '../models/dashboard_stats.dart';
import 'api_service.dart';

class DashboardService {
  Future<DashboardStats> getStats(String userId) async {
    final response = await ApiService.instance.get(
      "/dashboard/$userId",
    );

    return DashboardStats.fromJson(response.data);
  }
}