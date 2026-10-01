import '../datasources/firestore_post_datasource.dart';
import '../datasources/local_post_datasource.dart';

enum PostDataSourceType { remote, local }

class PostDataSourceFactory {
  final FirestorePostDataSource _remoteDataSource;
  final LocalPostDataSource _localDataSource;

  PostDataSourceFactory(this._remoteDataSource, this._localDataSource);

  dynamic create(PostDataSourceType type) {
    switch (type) {
      case PostDataSourceType.remote:
        return _remoteDataSource;

      case PostDataSourceType.local:
        return _localDataSource;
    }
  }
}
