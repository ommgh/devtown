import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/Features/post/controllers/post_controller.dart';
import 'package:todoapp/Features/post/widgets/post_card.dart';
import 'package:todoapp/common/common.dart';
import 'package:todoapp/constants/constants.dart';
import 'package:todoapp/models/post_model.dart';

class PostReplyScreen extends ConsumerWidget {
  static route(Post post) => MaterialPageRoute(
        builder: (context) => PostReplyScreen(
          post: post,
        ),
      );
  final Post post;
  const PostReplyScreen({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post"),
      ),
      body: Column(
        children: [
          PostCard(post: post),
          ref.watch(getRepliesToPostsProvider(post)).when(
                data: (posts) {
                  return ref.watch(getLatestPostProvider).when(
                        data: (data) {
                          if (data.events.contains(
                            'databases.*.collections.${AppwriteContants.postCollection}.documents.*.create',
                          )) {
                            posts.insert(0, Post.fromMap(data.payload));
                          }

                          return Expanded(
                            child: ListView.builder(
                              itemCount: posts.length,
                              itemBuilder: (BuildContext context, int index) {
                                final post = posts[index];
                                return PostCard(post: post);
                              },
                            ),
                          );
                        },
                        error: (error, stackTrace) => ErrorText(
                          error: error.toString(),
                        ),
                        loading: () {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: posts.length,
                              itemBuilder: (BuildContext context, int index) {
                                final post = posts[index];
                                return PostCard(post: post);
                              },
                            ),
                          );
                        },
                      );
                },
                error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                ),
                loading: () => const Loader(),
              ),
        ],
      ),
      bottomNavigationBar: TextField(
        onSubmitted: (value) {
          ref.read(postControllerProvider.notifier).sharePost(
            images: [],
            text: value,
            context: context,
            repliedTo: post.id,
          );
        },
        decoration: const InputDecoration(
          hintText: "Your Reply",
        ),
      ),
    );
  }
}
