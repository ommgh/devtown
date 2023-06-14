import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoapp/Features/explore/views/explore_view.dart';
import 'package:todoapp/Features/notifications/views/notification_view.dart';
import 'package:todoapp/constants/constants.dart';
import 'package:todoapp/Features/post/widgets/post_list.dart';
import 'package:todoapp/theme/pallet.dart';

class UIConstants {
  static AppBar appBar() {
    return AppBar(
      title: Text(
        "Devtown.",
        style: GoogleFonts.leagueSpartan(
          textStyle: const TextStyle(
            color: Color.fromARGB(255, 42, 209, 33),
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
      ),
      centerTitle: true,
    );
  }

  static const List<Widget> bottomTabBarPages = [
    PostList(),
    ExploreView(),
    NotificationView(),
  ];
}
