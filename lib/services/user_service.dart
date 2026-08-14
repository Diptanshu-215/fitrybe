import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'api_client.dart';

class UserService {
  final ApiClient _client = ApiClient();

  Future<Map<String, dynamic>?> updateProfile(Map<String, dynamic> body) async {
    try {
      final res = await _client.patch('/users/me', body: body);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['user'];
      }
    } catch (e) {
      debugPrint('UserService updateProfile error: $e');
    }
    return null;
  }

  Future<String?> uploadAvatar(File imageFile) async {
    try {
      final fileStream = http.ByteStream(imageFile.openRead());
      final length = await imageFile.length();
      final file = http.MultipartFile(
        'avatar',
        fileStream,
        length,
        filename: imageFile.path.split('/').last,
      );

      final res = await _client.multipartPost('/users/me/avatar', files: [file]);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['user']?['avatarUrl'];
      }
    } catch (e) {
      debugPrint('UserService uploadAvatar error: $e');
    }
    return null;
  }

  Future<bool> followUser(String targetUserId) async {
    try {
      final res = await _client.post('/users/$targetUserId/follow');
      return res.statusCode == 201;
    } catch (e) {
      debugPrint('UserService followUser error: $e');
    }
    return false;
  }

  Future<bool> unfollowUser(String targetUserId) async {
    try {
      final res = await _client.delete('/users/$targetUserId/follow');
      return res.statusCode == 200;
    } catch (e) {
      debugPrint('UserService unfollowUser error: $e');
    }
    return false;
  }
}
