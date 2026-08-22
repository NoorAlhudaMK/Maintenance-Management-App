import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../Core/AppConstants/app_constants.dart';
import '../../Core/CacheManager/cache_manager.dart';
import '../Models/user_model.dart';

class AuthRepository {
  Future<UserModel> login(String username, String password) async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    final url = Uri.parse(AppConstants.loginEndpoint);
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      "jsonrpc": "2.0",
      "params": {
        "db": AppConstants.dbName,
        "login": username,
        "password": password,
        "device_token": fcmToken ?? "no_token",
      },
    });

    if (kDebugMode) {
      print("LOGIN REQUEST -> URL: $url");
      print("LOGIN REQUEST -> Headers: $headers");
      print("LOGIN REQUEST -> Body: $body");
    }

    final response = await http.post(url, headers: headers, body: body);

    if (kDebugMode) {
      print("LOGIN RESPONSE -> Status: ${response.statusCode}");
      print("LOGIN RESPONSE -> Body: ${response.body}");
    }

    if (kDebugMode) {
      print("The data 22 : ${response.body}");
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (kDebugMode) {
        print("The data : ${data}");
      }
      if (data['success'] == true && data['data'] != null) {
        return UserModel.fromJson(data['data'], token: data['data']['token']);
      } else {
        throw Exception(data['message'] ?? "خطأ في بيانات الدخول");
      }
    } else {
      throw Exception("فشل الاتصال بالسيرفر");
    }
  }

  Future<bool> checkUserAccess(String token) async {
    final url = Uri.parse('${AppConstants.baseUrl}/api/v1/auth/access-groups');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    if (kDebugMode) {
      print("CHECK ACCESS REQUEST -> URL: $url");
      print("CHECK ACCESS REQUEST -> Headers: $headers");
    }

    final response = await http.get(url, headers: headers);

    if (kDebugMode) {
      print("CHECK ACCESS RESPONSE -> Status: ${response.statusCode}");
      print("CHECK ACCESS RESPONSE -> Body: ${response.body}");
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        List<dynamic> allowedApps = data['data']['allowed_apps'];
        if (kDebugMode) {
          print("The data : ${allowedApps.length}");
        }
        return allowedApps.contains('maintenance');
      }
    }
    return false;
  }

  Future<UserModel> getUserProfile(String token) async {
    final url = Uri.parse('${AppConstants.baseUrl}/api/v1/user/profile');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    if (kDebugMode) {
      print("GET PROFILE REQUEST -> URL: $url");
      print("GET PROFILE REQUEST -> Headers: $headers");
    }

    final response = await http.get(url, headers: headers);

    if (kDebugMode) {
      print("GET PROFILE RESPONSE -> Status: ${response.statusCode}");
      print("GET PROFILE RESPONSE -> Body: ${response.body}");
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return UserModel.fromJson(data['data'], token: token);
      }
    }
    throw Exception("فشل في جلب بيانات المستخدم");
  }

  Future<void> sendDeviceToken(String authToken, String firebaseToken) async {
    final url = Uri.parse('${AppConstants.baseUrl}/api/v1/notifications/register-token');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $authToken",
    };
    final body = jsonEncode({
      "device_token": firebaseToken,
      "platform": "android",
      "app_name": "maintenance",
      "device_name": "Android Device",
    });

    if (kDebugMode) {
      print("SEND DEVICE TOKEN REQUEST -> URL: $url");
      print("SEND DEVICE TOKEN REQUEST -> Headers: $headers");
      print("SEND DEVICE TOKEN REQUEST -> Body: $body");
    }

    final response = await http.post(url, headers: headers, body: body);

    if (kDebugMode) {
      print("SEND DEVICE TOKEN RESPONSE -> Status: ${response.statusCode}");
      print("SEND DEVICE TOKEN RESPONSE -> Body: ${response.body}");
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] != true) {
        throw Exception(data['message'] ?? "فشل في تسجيل توكن الجهاز");
      }
    } else {
      throw Exception("فشل في إرسال توكن الجهاز");
    }
  }

  Future<UserModel> fetchAndCacheUserProfile(String authToken) async {
    bool hasAccess = await checkUserAccess(authToken);
    if (!hasAccess) throw Exception("ليس لديك صلاحية");

    final user = await getUserProfile(authToken);

    await CacheManager.saveSensitiveData(token: authToken);
    await CacheManager.saveUserData(user);
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        await sendDeviceToken(authToken, fcmToken);
      }
    } catch (e) {
      if (kDebugMode) {
        print("خطأ في إرسال التوكن: $e");
      }
    }

    return user;
  }

  Future<void> logout(String token) async {
    final url = Uri.parse('${AppConstants.baseUrl}/api/v1/auth/logout');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    if (kDebugMode) {
      print("LOGOUT REQUEST -> URL: $url");
      print("LOGOUT REQUEST -> Headers: $headers");
    }

    final response = await http.post(url, headers: headers);

    if (kDebugMode) {
      print("LOGOUT RESPONSE -> Status: ${response.statusCode}");
      print("LOGOUT RESPONSE -> Body: ${response.body}");
    }

    if (response.statusCode != 200) {
      throw Exception('Failed to logout');
    }
  }

  Future<String> forgotPassword(String email) async {
    final url = Uri.parse('${AppConstants.baseUrl}/api/v1/auth/forgot-password');
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      "email": email,
    });

    if (kDebugMode) {
      print("FORGOT PASSWORD REQUEST -> URL: $url");
      print("FORGOT PASSWORD REQUEST -> Headers: $headers");
      print("FORGOT PASSWORD REQUEST -> Body: $body");
    }

    final response = await http.post(url, headers: headers, body: body);

    if (kDebugMode) {
      print("FORGOT PASSWORD RESPONSE -> Status: ${response.statusCode}");
      print("FORGOT PASSWORD RESPONSE -> Body: ${response.body}");
    }

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      return data['message'] ?? "تم إرسال تعليمات استعادة كلمة المرور بنجاح.";
    } else {
      throw Exception(data['message'] ?? "فشل في إرسال طلب استعادة كلمة المرور");
    }
  }
}