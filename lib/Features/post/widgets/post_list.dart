import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/Features/post/controllers/post_controller.dart';
import 'package:todoapp/Features/post/widgets/post_card.dart';
import 'package:todoapp/common/common.dart';
import 'package:todoapp/models/post_model.dart';

import '../../../constants/constants.dart';

class PostList extends ConsumerWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getPostsProvider).when(
          data: (posts) {
            return ref.watch(getLatestPostProvider).when(
                  data: (data) {
                    if (data.events.contains(
                      'databases.*.collections.${AppwriteContants.postCollection}.documents.*.create',
                    )) {
                      posts.insert(0, Post.fromMap(data.payload));
                    }

                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (BuildContext context, int index) {
                        final post = posts[index];
                        return PostCard(post: post);
                      },
                    );
                  },
                  error: (error, stackTrace) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () {
                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (BuildContext context, int index) {
                        final post = posts[index];
                        return PostCard(post: post);
                      },
                    );
                  },
                );
          },
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
