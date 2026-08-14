import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../Core/CacheManager/cache_manager.dart';
import '../../../Core/AppConstants/app_constants.dart';
import '../Models/ticket_model.dart';

class TicketsRepository {
  Future<List<TicketModel>> fetchTickets() async {
    String? token = await CacheManager.getToken();

    print("Token value is: $token");

    if (token == null) {
      throw Exception("التوكن غير موجود - يرجى تسجيل الدخول مجدداً");
    }

    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/api/user/tickets'),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> ticketsJson = data['data']['tickets'];
      return ticketsJson.map((json) => TicketModel.fromJson(json)).toList();
    } else {
      print("Error: ${response.statusCode}, Body: ${response.body}");
      throw Exception("فشل في جلب التذاكر: ${response.statusCode}");
    }
  }
}
