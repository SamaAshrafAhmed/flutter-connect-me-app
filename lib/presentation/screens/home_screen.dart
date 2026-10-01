import 'package:connectme_app/presentation/blocs/states/auth_states.dart';
import 'package:connectme_app/presentation/blocs/states/post_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user.dart';
import '../../injection.dart';
import '../blocs/auth_cubit.dart';
import '../blocs/post_cubit.dart';
import '../widgets/post_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;

    if (authState is! AuthAuthenticated) {
      return const Scaffold(
        body: Center(child: Text('User is not authenticated')),
      );
    }

    return BlocProvider(
      create: (_) => getIt<PostCubit>()..loadPosts(),
      child: HomeView(user: authState.user),
    );
  }
}

class HomeView extends StatelessWidget {
  final UserEntity user;

  const HomeView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ConnectMe'),
        actions: [
          IconButton(
            onPressed: () {
              // Profile navigation will be added later.
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),

      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if (state is PostLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PostErrorState) {
            return Center(child: Text(state.error));
          }

          if (state is PostLoadedState) {
            if (state.posts.isEmpty) {
              return const Center(child: Text('No posts yet.'));
            }

            return ListView.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                return PostCard(post: state.posts[index]);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreatePostDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Create Post'),

          content: TextField(
            controller: controller,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Write something...',
              border: OutlineInputBorder(),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                final content = controller.text.trim();

                if (content.isEmpty) {
                  return;
                }

                context.read<PostCubit>().createPost(
                  authorId: user.id,
                  authorName: user.fullName,
                  content: content,
                );

                Navigator.pop(dialogContext);
              },
              child: const Text('Post'),
            ),
          ],
        );
      },
    );
  }
}
