import '../models/post_model.dart';

class LocalPostDataSource {
  List<PostModel> _cachedPosts = [];

  Future<List<PostModel>> getPosts() async {
    return _cachedPosts;
  }

  Future<void> savePosts(
    List<PostModel> posts,
  ) async {
    _cachedPosts = posts;
  }

  Future<void> clearPosts() async {
    _cachedPosts = [];
  }
}