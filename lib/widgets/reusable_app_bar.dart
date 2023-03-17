import 'package:flutter/material.dart';

import '../constants/values/colors.dart';

class ReusableAppBar extends StatelessWidget implements PreferredSizeWidget {
  String text;
  double width;
  double height;
  ReusableAppBar({Key? key, required this.text, required this.width, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return AppBar(
      toolbarHeight: height * 0.07,
      backgroundColor: UiColorHelper.mainYellow,
      elevation: 1,
      centerTitle: true,
      title: Text(
        text,
        style: textTheme.subtitle1,
      ),
    );
  }

  @override
  Size get preferredSize => Size(width, height * 0.07);
}
