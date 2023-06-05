import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todoapp/Constants/constants.dart';
import 'package:todoapp/theme/pallet.dart';

class UIConstants {
  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(
        AssetsConstants.logo,
        color: Pallete.blueColor,
        height: 30,
      ),
      centerTitle: true,
    );
  }

  static List<Widget> bottomTabBarPages = [
    Text("Feed Screen"),
    Text("Search Screen"),
    Text("Notification Screen"),
  ];
}
