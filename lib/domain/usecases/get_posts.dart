import 'package:connectme_app/domain/entities/post.dart';
import 'package:connectme_app/domain/repositories/post_repository.dart';

class GetPosts {
  final PostRepository _postRepository;
  new(this._postRepository);

  Stream<List<Post>> call() {
    return _postRepository.getPosts();
  }
}
