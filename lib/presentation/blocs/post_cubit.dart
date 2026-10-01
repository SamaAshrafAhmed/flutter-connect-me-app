import 'dart:async';

import 'package:connectme_app/domain/entities/post.dart';
import 'package:connectme_app/domain/usecases/create_post.dart';
import 'package:connectme_app/domain/usecases/get_posts.dart';
import 'package:connectme_app/presentation/blocs/states/post_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostCubit extends Cubit<PostState> {
  final CreatePost _createPost;
  final GetPosts _getPosts;
  StreamSubscription<List<Post>>? _postsSubscription;
  new(this._createPost, this._getPosts) : super(PostInitialState());

  void loadPosts() {
    emit(PostLoadingState());

    _postsSubscription?.cancel();

    _postsSubscription = _getPosts().listen(
      (posts) {
        emit(PostLoadedState(posts));
      },
      onError: (error) {
        emit(PostErrorState('Unable to load posts. Please try again.'));
      },
    );
  }

  Future<void> createPost({
    required String authorId,
    required String authorName,
    required String content,
  }) async {
    try {
      final post = Post(
        id: '',
        authorId: authorId,
        authorName: authorName,
        content: content,
        timestamp: DateTime.now(),
      );

      await _createPost(post);
    } catch (e) {
      emit(PostErrorState('Unable to create the post. Please try again.'));
    }
  }

  @override
  Future<void> close() {
    _postsSubscription?.cancel();
    return super.close();
  }
}
