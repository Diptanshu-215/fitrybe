import 'package:flutter/foundation.dart';

/// A simple in-memory post model.
class UserPost {
  final String id;
  final String caption;
  final String type;
  final String audience;
  final String? locationTag;
  final List<String> imagePaths; // local file paths (XFile.path)
  final DateTime createdAt;

  UserPost({
    required this.id,
    required this.caption,
    required this.type,
    required this.audience,
    this.locationTag,
    required this.imagePaths,
    required this.createdAt,
  });
}

/// Singleton store that any screen can read from / write to.
class PostStore extends ChangeNotifier {
  static final PostStore instance = PostStore._();
  PostStore._();

  final List<UserPost> _posts = [];

  List<UserPost> get posts => List.unmodifiable(_posts);

  void addPost(UserPost post) {
    _posts.insert(0, post); // newest first
    notifyListeners();
  }

  void removePost(String id) {
    _posts.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
