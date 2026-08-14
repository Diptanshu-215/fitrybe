import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'api_client.dart';

class TrybeService {
  final ApiClient _client = ApiClient();

  Future<List<Map<String, dynamic>>> getTrybes({bool mineOnly = false}) async {
    try {
      final endpoint = '/trybes${mineOnly ? '?mine=true' : ''}';
      final res = await _client.get(endpoint);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final List trybes = data['trybes'] ?? [];
        return List<Map<String, dynamic>>.from(trybes);
      }
    } catch (e) {
      debugPrint('TrybeService getTrybes error: $e');
    }
    return [];
  }

  Future<Map<String, dynamic>?> createTrybe({
    required String name,
    String? description,
    String? category,
    String? location,
    bool isPublic = true,
    File? imageFile,
  }) async {
    try {
      final fields = <String, String>{
        'name': name,
        'isPublic': isPublic.toString(),
      };
      if (description != null) fields['description'] = description;
      if (category != null) fields['category'] = category;
      if (location != null) fields['location'] = location;

      List<http.MultipartFile>? files;
      if (imageFile != null) {
        final fileStream = http.ByteStream(imageFile.openRead());
        final length = await imageFile.length();
        files = [
          http.MultipartFile(
            'image',
            fileStream,
            length,
            filename: imageFile.path.split('/').last,
          )
        ];
      }

      final res = await _client.multipartPost('/trybes', fields: fields, files: files);
      if (res.statusCode == 201) {
        final data = jsonDecode(res.body);
        return data['trybe'];
      }
    } catch (e) {
      debugPrint('TrybeService createTrybe error: $e');
    }
    return null;
  }

  Future<bool> joinTrybe(String trybeId) async {
    try {
      final res = await _client.post('/trybes/$trybeId/join');
      return res.statusCode == 201;
    } catch (e) {
      debugPrint('TrybeService joinTrybe error: $e');
    }
    return false;
  }

  Future<bool> leaveTrybe(String trybeId) async {
    try {
      final res = await _client.delete('/trybes/$trybeId/join');
      return res.statusCode == 200;
    } catch (e) {
      debugPrint('TrybeService leaveTrybe error: $e');
    }
    return false;
  }

  Future<List<Map<String, dynamic>>> getMembers(String trybeId) async {
    try {
      final res = await _client.get('/trybes/$trybeId/members');
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final List members = data['members'] ?? [];
        return List<Map<String, dynamic>>.from(members);
      }
    } catch (e) {
      debugPrint('TrybeService getMembers error: $e');
    }
    return [];
  }
}
