import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../Core/CacheManager/cache_manager.dart';
import '../../../Core/AppConstants/app_constants.dart';
import '../Models/category_model.dart';
import '../Models/maintenance_team_member_model.dart';
import '../Models/maintenance_team_model.dart';
import '../Models/priority_model.dart';
import '../Models/status_model.dart';
import '../Models/ticket_model.dart';

class TicketsRepository {
  Future<Map<String, dynamic>> createTicket({
    required String title,
    required String description,
    required int categoryId,
    required int unitId,
    required String priority,
    int? teamId,
    String? expectedDate,
    List<Map<String, dynamic>>? images,
  }) async {
    String? token = await CacheManager.getToken();

    final uri = Uri.parse('${AppConstants.baseUrl}/api/v1/tickets');

    final Map<String, dynamic> body = {
      "title": title,
      "description": description,
      "category_id": categoryId,
      "unit_id": unitId,
      "priority": priority,
      if (teamId != null) "team_id": teamId,
      if (expectedDate != null) "expected_date": expectedDate,
      if (images != null) "images": images,
    };

    final response = await http.post(
      uri,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? "فشل إرسال البلاغ");
    }
  }

  Future<List<TicketModel>> fetchTickets({
    String? dateFrom,
    String? dateTo,
    String? search,
    String? status,
    String? priority,
  }) async {
    String? token = await CacheManager.getToken();

    Map<String, String> queryParams = {};
    if (dateFrom != null) queryParams['date_from'] = dateFrom;
    if (dateTo != null) queryParams['date_to'] = dateTo;
    if (search != null) queryParams['search'] = search;
    if (status != null) queryParams['status'] = status;
    if (priority != null) queryParams['priority'] = priority.toString();

    final uri = Uri.parse('${AppConstants.baseUrl}/api/v1/technician/tasks')
        .replace(queryParameters: queryParams);

    final response = await http.get(uri, headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    });

    print("The filter request: ${response.request}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> ticketsJson = data['data']['tickets'];
      print("The filter response: ${response.body}");
      return ticketsJson.map((json) => TicketModel.fromJson(json)).toList();
    } else {
      throw Exception("فشل جلب البيانات");
    }
  }

  Future<Map<String, dynamic>> fetchTaskDetails(String taskId) async {
    String? token = await CacheManager.getToken();

    final uri = Uri.parse('${AppConstants.baseUrl}/api/v1/tickets/$taskId');

    final response = await http.get(uri, headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['ticket'];
    } else {
      throw Exception("فشل جلب تفاصيل التذكرة");
    }
  }

  Future<List<PriorityModel>> fetchPriorities() async {
    String? token = await CacheManager.getToken();
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/api/v1/maintenance/priorities'),
      headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> list = data['data']['priorities'];
      return list.map((json) => PriorityModel.fromJson(json)).toList();
    } else {
      throw Exception("فشل جلب الأولويات");
    }
  }

  Future<List<CategoryModel>> fetchCategories({int? teamId}) async {
    String? token = await CacheManager.getToken();

    Map<String, String> queryParams = {};
    if (teamId != null) queryParams['team_id'] = teamId.toString();

    final uri = Uri.parse('${AppConstants.baseUrl}/api/v1/maintenance/categories')
        .replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

    final response = await http.get(
      uri,
      headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> list = data['data']['categories'];
      return list.map((json) => CategoryModel.fromJson(json)).toList();
    } else {
      throw Exception("فشل جلب الفئات");
    }
  }

  Future<List<StatusModel>> fetchStatuses({int? teamId}) async {
    String? token = await CacheManager.getToken();

    Map<String, String> queryParams = {};
    if (teamId != null) queryParams['team_id'] = teamId.toString();

    final uri = Uri.parse('${AppConstants.baseUrl}/api/v1/maintenance/statuses')
        .replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

    final response = await http.get(
      uri,
      headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> list = data['data']['statuses'];
      return list.map((json) => StatusModel.fromJson(json)).toList();
    } else {
      throw Exception("فشل جلب الحالات");
    }
  }

  Future<Map<String, dynamic>> assignTicket({
    required String ticketId,
    required String technicianId,
    String? teamId,
  }) async {
    String? token = await CacheManager.getToken();
    final uri = Uri.parse('${AppConstants.baseUrl}/api/v1/maintenance/tickets/assign');

    final Map<String, dynamic> body = {
      "ticket_id": ticketId,
      "technician_id": technicianId,
      if (teamId != null) "team_id": teamId,
    };

    final response = await http.post(
      uri,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? "فشل إسناد المهمة");
    }
  }

  Future<List<MaintenanceTeamModel>> fetchTeams() async {
    String? token = await CacheManager.getToken();
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/api/v1/maintenance/teams'),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final List<dynamic> teamsList = responseBody['data']['teams'];

      return teamsList.map((teamJson) => MaintenanceTeamModel.fromJson(teamJson)).toList();

    } else {
      throw Exception("فشل جلب الفرق: ${response.statusCode}");
    }
  }

  Future<List<TeamMemberModel>> fetchTeamMembers({
    int? teamId,
    String? search,
  }) async {
    String? token = await CacheManager.getToken();

    Map<String, String> queryParams = {};
    if (teamId != null) queryParams['team_id'] = teamId.toString();
    if (search != null && search.isNotEmpty) queryParams['search'] = search;

    final uri = Uri.parse('${AppConstants.baseUrl}/api/v1/maintenance/members')
        .replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

    final response = await http.get(
      uri,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> membersJson = data['data']['members'];
      return membersJson
          .map((json) => TeamMemberModel.fromJson(json))
          .toList();
    } else {
      throw Exception("فشل جلب أعضاء الفريق: ${response.statusCode}");
    }
  }
}