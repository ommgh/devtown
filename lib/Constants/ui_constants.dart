import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todoapp/constants/constants.dart';
import 'package:todoapp/Features/post/widgets/post_list.dart';
import 'package:todoapp/theme/pallet.dart';

class UIConstants {
  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(
        AssetsConstants.logo,
        color: Pallete.greencolor,
        height: 30,
      ),
      centerTitle: true,
    );
  }

  static const List<Widget> bottomTabBarPages = [
    PostList(),
    Text("Search Screen"),
    Text("Notification Screen"),
  ];
}
