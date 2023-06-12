import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';
import 'package:todoapp/Features/post/controllers/post_controller.dart';
import 'package:todoapp/constants/assets_constant.dart';
import 'package:todoapp/Features/auth/controller/auth_controller.dart';
import 'package:todoapp/Features/post/widgets/carousel_image.dart';
import 'package:todoapp/Features/post/widgets/hashtag_text.dart';
import 'package:todoapp/Features/post/widgets/post_icon_button.dart';
import 'package:todoapp/common/common.dart';
import 'package:todoapp/core/enums/post_type.dart';
import 'package:todoapp/models/post_model.dart';
import 'package:todoapp/theme/pallet.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null
        ? const SizedBox()
        : ref.watch(userDetailsProvider(post.uid)).when(
              data: (user) {
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(user.profilePic),
                            radius: 25,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  ),
                                  Text(
                                    '@${user.name} . ${timeago.format(
                                      post.postedAt,
                                      locale: 'en_short',
                                    )}',
                                    style: const TextStyle(
                                      color: Pallete.greyColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),

                              //repliedto
                              HashtagText(text: post.text),
                              if (post.postType == PostType.image)
                                CarouselImage(imageLinks: post.imageLinks),
                              if (post.link.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                AnyLinkPreview(
                                    displayDirection:
                                        UIDirection.uiDirectionHorizontal,
                                    link: 'https://${post.link}'),
                              ],
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 10,
                                  right: 20,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    PostIconButton(
                                      pathName: AssetsConstants.viewicon,
                                      text: (post.commentIds.length +
                                              post.reshareCount +
                                              post.likes.length)
                                          .toString(),
                                      onTap: () {},
                                    ),
                                    PostIconButton(
                                      pathName: AssetsConstants.commenticon,
                                      text: post.commentIds.length.toString(),
                                      onTap: () {},
                                    ),
                                    LikeButton(
                                      size: 25,
                                      onTap: (isLiked) async {
                                        ref
                                            .read(
                                                postControllerProvider.notifier)
                                            .likePost(post, currentUser);
                                        return !isLiked;
                                      },
                                      isLiked:
                                          post.likes.contains(currentUser.uid),
                                      likeBuilder: (isLiked) {
                                        return isLiked
                                            ? SvgPicture.asset(
                                                AssetsConstants
                                                    .homeFilled, //Replace With Upvote
                                                color: Pallete.redcolor,
                                              )
                                            : SvgPicture.asset(
                                                AssetsConstants
                                                    .homeOutlined, //Replace With Downvote
                                                color: Pallete.greyColor,
                                              );
                                      },
                                      likeCount: post.likes.length,
                                      countBuilder: (likeCount, isLiked, text) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(left: 2.0),
                                          child: Text(
                                            text,
                                            style: TextStyle(
                                              color: isLiked
                                                  ? Pallete.redcolor
                                                  : Pallete.whiteColor,
                                              fontSize: 16,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.share_outlined,
                                        size: 25,
                                        color: Pallete.greyColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 1),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Pallete.greyColor),
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
