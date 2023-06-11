import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/Features/auth/controller/auth_controller.dart';
import 'package:todoapp/common/common.dart';
import 'package:todoapp/models/post_model.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userDetailsProvider(post.uid)).when(
          data: (user) {
            return Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(user.profilePic),
                        radius: 25,
                      ),
                    ),
                    Column(
                      children: [
                        //Reshare
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 5),
                              child: Text(
                                user.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
