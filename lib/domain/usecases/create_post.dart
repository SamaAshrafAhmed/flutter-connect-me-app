import 'package:connectme_app/domain/entities/post.dart';
import 'package:connectme_app/domain/repositories/post_repository.dart';

class CreatePost {
  final PostRepository _postRepository;
  new(this._postRepository);

  Future<void> call(Post post) async {
    await _postRepository.createPost(post);
  }
}
