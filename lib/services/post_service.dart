import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'api_client.dart';

class PostService {
  final ApiClient _client = ApiClient();

  Future<List<Map<String, dynamic>>> fetchFeed({String? cursor, int limit = 20}) async {
    try {
      final query = StringBuffer('/posts?limit=$limit');
      if (cursor != null && cursor.isNotEmpty) {
        query.write('&cursor=$cursor');
      }

      final res = await _client.get(query.toString());
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final List posts = data['posts'] ?? [];
        return List<Map<String, dynamic>>.from(posts);
      }
    } catch (e) {
      debugPrint('PostService fetchFeed error: $e');
    }
    return [];
  }

  Future<Map<String, dynamic>?> createPost({
    required String caption,
    String type = 'Update',
    String audience = 'EVERYONE',
    String? locationTag,
    List<File>? imageFiles,
  }) async {
    try {
      final fields = <String, String>{
        'caption': caption,
        'type': type,
        'audience': audience,
      };
      if (locationTag != null && locationTag.isNotEmpty) {
        fields['locationTag'] = locationTag;
      }

      List<http.MultipartFile>? files;
      if (imageFiles != null && imageFiles.isNotEmpty) {
        files = [];
        for (var file in imageFiles) {
          final fileStream = http.ByteStream(file.openRead());
          final length = await file.length();
          final multipartFile = http.MultipartFile(
            'images',
            fileStream,
            length,
            filename: file.path.split('/').last,
          );
          files.add(multipartFile);
        }
      }

      final res = await _client.multipartPost('/posts', fields: fields, files: files);
      if (res.statusCode == 201) {
        final data = jsonDecode(res.body);
        return data['post'];
      }
    } catch (e) {
      debugPrint('PostService createPost error: $e');
    }
    return null;
  }

  Future<bool> likePost(String postId) async {
    try {
      final res = await _client.post('/posts/$postId/like');
      return res.statusCode == 201;
    } catch (e) {
      debugPrint('PostService likePost error: $e');
    }
    return false;
  }

  Future<bool> unlikePost(String postId) async {
    try {
      final res = await _client.delete('/posts/$postId/like');
      return res.statusCode == 200;
    } catch (e) {
      debugPrint('PostService unlikePost error: $e');
    }
    return false;
  }

  Future<List<Map<String, dynamic>>> fetchComments(String postId) async {
    try {
      final res = await _client.get('/posts/$postId/comments');
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final List comments = data['comments'] ?? [];
        return List<Map<String, dynamic>>.from(comments);
      }
    } catch (e) {
      debugPrint('PostService fetchComments error: $e');
    }
    return [];
  }

  Future<Map<String, dynamic>?> addComment(String postId, String text) async {
    try {
      final res = await _client.post('/posts/$postId/comments', body: {'text': text});
      if (res.statusCode == 201) {
        final data = jsonDecode(res.body);
        return data['comment'];
      }
    } catch (e) {
      debugPrint('PostService addComment error: $e');
    }
    return null;
  }
}
