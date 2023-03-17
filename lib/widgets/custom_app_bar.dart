import 'package:emarketapp/constants/dimens/uihelper.dart';
import 'package:emarketapp/constants/paths/paths.dart';
import 'package:emarketapp/constants/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBar({Key? key, required this.width, required this.height, required this.selectedIndex}) : super(key: key);

  final double width;
  final double height;
  int selectedIndex;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size(width, height / 100 * 7);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: () {
        if (widget.selectedIndex == 0) {
          return AppBarMain(
            widget: widget,
          );
        } else if (widget.selectedIndex == 1) {
          return AppBarWithText(
            widget: widget,
            text: 'Fırsat Ürünler',
          );
        } else if (widget.selectedIndex == 3) {
          return AppBarWithText(
            widget: widget,
            text: 'Sepet',
          );
        } else if (widget.selectedIndex == 4) {
          return AppBarWithText(
            widget: widget,
            text: 'Hesabım',
          );
        } else {
          return AppBarMain(
            widget: widget,
          );
        }
      }(),
    );
  }
}

class AppBarWithText extends StatelessWidget {
  const AppBarWithText({Key? key, required this.widget, required this.text}) : super(key: key);

  final CustomAppBar widget;
  final String text;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: widget.height / 100 * 7,
      backgroundColor: UiColorHelper.mainYellow,
      elevation: 1,
      centerTitle: true,
      title: Text(
        text,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}

class AppBarMain extends StatelessWidget {
  const AppBarMain({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final CustomAppBar widget;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: widget.height / 100 * 7,
      backgroundColor: UiColorHelper.mainYellow,
      elevation: 1,
      centerTitle: true,
      title: Image.asset(
        Paths.logoImagePath,
        height: widget.height / 100 * 8,
      ),
      actions: [
        Padding(
          padding: UiHelper.rightPadding2x,
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications,
              color: Colors.black,
            ),
          ),
        )
      ],
    );
  }
}
