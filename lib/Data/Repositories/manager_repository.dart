import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../Core/CacheManager/cache_manager.dart';
import '../../../Core/AppConstants/app_constants.dart';

class ManagerRepository {
  Future<Map<String, dynamic>> fetchManagerSummary({
    required int teamId,
    String? date,
    String? dateFrom,
    String? dateTo,
    int? assignedUserId,
  }) async {
    String? token = await CacheManager.getToken();

    Map<String, String> queryParams = {
      'team_id': teamId.toString(),
    };
    if (date != null) queryParams['date'] = date;
    if (dateFrom != null) queryParams['date_from'] = dateFrom;
    if (dateTo != null) queryParams['date_to'] = dateTo;
    if (assignedUserId != null) queryParams['assigned_user_id'] = assignedUserId.toString();

    final uri = Uri.parse('${AppConstants.baseUrl}/api/v1/maintenance/summary')
        .replace(queryParameters: queryParams);

    final response = await http.get(uri, headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        // تحويل الـ Map القادمة بأمان إلى Map<String, dynamic>
        return (data['data'] as Map).map((key, value) => MapEntry(key.toString(), value));
      } else {
        throw Exception(data['message'] ?? "فشل جلب الملخص");
      }
    } else {
      throw Exception("فشل الاتصال بالسيرفر");
    }
  }
}