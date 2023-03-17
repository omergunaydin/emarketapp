import 'package:flutter/material.dart';

import '../constants/dimens/uihelper.dart';
import '../constants/values/colors.dart';

class ReusableButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final Color? color;
  const ReusableButton({Key? key, required this.text, required this.onPressed, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: UiHelper.verticalSymmetricPadding1x,
      child: SizedBox(
        height: height / 100 * 6,
        width: width,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.black,
            shape: RoundedRectangleBorder(borderRadius: UiHelper.borderRadiusCircular1x),
          ),
          child: Text(
            text,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
