import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todoapp/Constants/assets_constant.dart';
import 'package:todoapp/Features/auth/controller/auth_controller.dart';
import 'package:todoapp/common/common.dart';
import 'package:todoapp/common/rounded_small_button.dart';
import 'package:todoapp/theme/pallet.dart';

class CreatePost extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const CreatePost(),
      );
  const CreatePost({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatePostState();
}

class _CreatePostState extends ConsumerState<CreatePost> {
  final postTextController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    postTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close, size: 30),
        ),
        actions: [
          RoundedSmallButton(
            onTap: () {},
            label: "Post",
            backgroundColor: Pallete.greencolor,
            textColor: Pallete.whiteColor,
          )
        ],
      ),
      body: currentUser == null
          ? const Loader()
          : SafeArea(
              child: SingleChildScrollView(
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(currentUser.profilePic),
                      radius: 21,
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextField(
                        controller: postTextController,
                        style: const TextStyle(
                          fontSize: 22,
                        ),
                        decoration: const InputDecoration(
                          hintText: "What's Going On!",
                          hintStyle: TextStyle(
                            color: Pallete.greyColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(
          bottom: 10,
        ),
        decoration: const BoxDecoration(
          border: Border(
              top: BorderSide(
            color: Pallete.greyColor,
            width: 0.8,
          )),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(
                left: 15,
                right: 15,
              ),
              child: SvgPicture.asset(AssetsConstants.galery),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(
                left: 15,
                right: 15,
              ),
              child: SvgPicture.asset(AssetsConstants.gif),
            ),
          ],
        ),
      ),
    );
  }
}
