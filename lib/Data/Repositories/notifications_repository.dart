import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Core/AppConstants/app_constants.dart';
import '../../Core/CacheManager/cache_manager.dart';
import '../Models/notifications_response_model.dart';
class NotificationsRepository {

  Future<NotificationsResponse> getNotifications({
    String? type,
    bool? unread,
    int page = 1,
    int perPage = 20,
  }) async {
    String? token = await CacheManager.getToken();

    final Map<String, String> queryParams = {
      'page': page.toString(),
      'per_page': perPage.toString(),
    };
    if (type != null) queryParams['type'] = type;
    if (unread != null) queryParams['unread'] = unread.toString();

    final uri = Uri.parse('${AppConstants.baseUrl}/api/v1/notifications')
        .replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return NotificationsResponse.fromJson(data);
    } else {
      throw Exception("فشل في تحميل الإشعارات: ${response.body}");
    }
  }

  Future<bool> markNotificationsAsRead(List<int> notificationIds) async {
    String? token = await CacheManager.getToken();
    final uri = Uri.parse('${AppConstants.baseUrl}/api/v1/notifications/read');

    final Map<String, dynamic> body = {
      "notification_ids": notificationIds,
    };

    final response = await http.post(
      uri,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['success'] ?? false;
    } else {
      throw Exception("فشل في تحديث حالة الإشعارات: ${response.body}");
    }
  }}