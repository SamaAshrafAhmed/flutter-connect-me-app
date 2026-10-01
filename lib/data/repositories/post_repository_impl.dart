import 'package:connectme_app/data/datasources/firestore_post_datasource.dart';
import 'package:connectme_app/data/models/post_model.dart';
import 'package:connectme_app/data/repositories/post_repository_factory.dart';
import 'package:connectme_app/domain/entities/post.dart';
import 'package:connectme_app/domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostDataSourceFactory _factory;

  new(this._factory);
  @override
  Future<void> createPost(Post post) async {
    final dataSource =
        _factory.create(PostDataSourceType.remote) as FirestorePostDataSource;

    final model = PostModel(
      id: post.id,
      authorId: post.authorId,
      authorName: post.authorName,
      content: post.content,
      timestamp: post.timestamp,
    );
    dataSource.createPost(model.toJson());
  }

  @override
  Stream<List<Post>> getPosts() {
    final dataSource =
        _factory.create(PostDataSourceType.remote) as FirestorePostDataSource;
    return dataSource.getPosts().map((snapshot) {
      return snapshot.docs.map((document) {
        return PostModel.fromJson({...document.data(), 'id': document.id});
      }).toList();
    });
  }
}
