import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../../Core/CacheManager/cache_manager.dart';
import '../../../Core/AppConstants/app_constants.dart';
import '../Models/maintenance_status_model.dart';
import '../Models/repair_ticket_response_model.dart';
import '../Models/ticket_image_response_model.dart';

class RepairDocumentationRepository {
  Future<RepairTicketResponse> submitRepair({
    required String taskId,
    required String status,
    required String notes,
    File? beforeImage,
    File? afterImage,
  }) async {
    String? token = await CacheManager.getToken();

    String endpointAction = "complete";
    if (status.contains("بدء") || status == "in_progress") {
      endpointAction = "start";
    } else if (status.contains("قبول")) {
      endpointAction = "accept";
    }

    final uri = Uri.parse('${AppConstants.baseUrl}/api/v1/technician/tasks/$taskId/$endpointAction');

    var request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    });

    request.fields['ticket_id'] = taskId;
    request.fields['status'] = status;
    request.fields['notes'] = notes;

    if (beforeImage != null) {
      request.files.add(await http.MultipartFile.fromPath('before_image', beforeImage.path));
    }
    if (afterImage != null) {
      request.files.add(await http.MultipartFile.fromPath('after_image', afterImage.path));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return RepairTicketResponse.fromJson(data);
    } else {
      throw Exception("فشل إرسال التقرير: ${response.body}");
    }
  }

  Future<List<MaintenanceStatusModel>> getMaintenanceStatuses() async {
    String? token = await CacheManager.getToken();
    final uri = Uri.parse('${AppConstants.baseUrl}/api/v1/maintenance/statuses');

    final response = await http.get(
      uri,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // التعامل مع مسار الـ statuses سواء كان داخل data أو في الجذر مباشرة
      List statusesList = data['data']?['statuses'] ?? data['statuses'] ?? [];
      return statusesList.map((json) => MaintenanceStatusModel.fromJson(json)).toList();
    } else {
      throw Exception("فشل في جلب الحالات: ${response.body}");
    }
  }

  Future<TicketImageResponse> uploadTaskImage({
    required String taskId,
    required File imageFile,
    required String imageType, // "before" أو "after"
    required String note,
  }) async {
    String? token = await CacheManager.getToken();
    final uri = Uri.parse('${AppConstants.baseUrl}/api/v1/technician/tasks/$taskId/upload-image');

    var request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    });

    request.fields['ticket_id'] = taskId;
    request.fields['image_type'] = imageType;
    request.fields['note'] = note;

    String fileName = imageFile.path.split('/').last;

    MediaType contentType = MediaType('image', 'jpeg');
    if (fileName.endsWith('.png')) {
      contentType = MediaType('image', 'png');
    }

    request.files.add(
      await http.MultipartFile.fromPath(
        'images[]',
        imageFile.path,
        filename: fileName,
        contentType: contentType,
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print("Upload Status Code: ${response.statusCode}");
    print("Upload Response Body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return TicketImageResponse.fromJson(data);
    } else {
      throw Exception("فشل رفع الصورة: ${response.body}");
    }
  }
}