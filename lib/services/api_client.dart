import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  static const String _tokenKey = 'fitrybe_access_token';
  static const String _refreshTokenKey = 'fitrybe_refresh_token';

  // Base URL configuration (auto-detects platform for emulator vs desktop/local)
  String get baseUrl {
    if (kIsWeb) return 'http://localhost:4000/api';
    if (Platform.isAndroid) return 'http://10.0.2.2:4000/api';
    return 'http://localhost:4000/api';
  }

  String get socketUrl {
    if (kIsWeb) return 'http://localhost:4000';
    if (Platform.isAndroid) return 'http://10.0.2.2:4000';
    return 'http://localhost:4000';
  }

  String? _accessToken;
  String? _refreshToken;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString(_tokenKey);
    _refreshToken = prefs.getString(_refreshTokenKey);
  }

  bool get isAuthenticated => _accessToken != null && _accessToken!.isNotEmpty;
  String? get token => _accessToken;

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
  }

  Map<String, String> get _headers {
    final map = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_accessToken != null && _accessToken!.isNotEmpty) {
      map['Authorization'] = 'Bearer $_accessToken';
    }
    return map;
  }

  Future<http.Response> get(String endpoint) async {
    try {
      final res = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
      );
      if (res.statusCode == 401 && _refreshToken != null) {
        final refreshed = await refreshToken();
        if (refreshed) {
          return await http.get(
            Uri.parse('$baseUrl$endpoint'),
            headers: _headers,
          );
        }
      }
      return res;
    } catch (e) {
      debugPrint('ApiClient GET error: $e');
      rethrow;
    }
  }

  Future<http.Response> post(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: body != null ? jsonEncode(body) : null,
      );
      if (res.statusCode == 401 && _refreshToken != null) {
        final refreshed = await refreshToken();
        if (refreshed) {
          return await http.post(
            Uri.parse('$baseUrl$endpoint'),
            headers: _headers,
            body: body != null ? jsonEncode(body) : null,
          );
        }
      }
      return res;
    } catch (e) {
      debugPrint('ApiClient POST error: $e');
      rethrow;
    }
  }

  Future<http.Response> patch(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final res = await http.patch(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: body != null ? jsonEncode(body) : null,
      );
      return res;
    } catch (e) {
      debugPrint('ApiClient PATCH error: $e');
      rethrow;
    }
  }

  Future<http.Response> delete(String endpoint) async {
    try {
      final res = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
      );
      return res;
    } catch (e) {
      debugPrint('ApiClient DELETE error: $e');
      rethrow;
    }
  }

  Future<http.Response> multipartPost(
    String endpoint, {
    Map<String, String>? fields,
    List<http.MultipartFile>? files,
  }) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse('$baseUrl$endpoint'));
      if (_accessToken != null && _accessToken!.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $_accessToken';
      }
      if (fields != null) {
        request.fields.addAll(fields);
      }
      if (files != null) {
        request.files.addAll(files);
      }
      final streamedResponse = await request.send();
      return await http.Response.fromStream(streamedResponse);
    } catch (e) {
      debugPrint('ApiClient Multipart error: $e');
      rethrow;
    }
  }

  Future<bool> refreshToken() async {
    if (_refreshToken == null) return false;
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': _refreshToken}),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        await saveTokens(data['accessToken'], data['refreshToken']);
        return true;
      }
    } catch (e) {
      debugPrint('ApiClient Token Refresh error: $e');
    }
    await clearTokens();
    return false;
  }
}
