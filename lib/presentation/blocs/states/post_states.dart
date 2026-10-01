import 'package:connectme_app/domain/entities/post.dart';

abstract class PostState {}

class PostInitialState extends PostState {}

class PostLoadingState extends PostState {}

class PostLoadedState extends PostState {
  final List<Post> posts;

  new(this.posts);
}

class PostErrorState extends PostState {
  final String error;

  new(this.error);
}
