import 'package:flutter/material.dart';
import '../constants/dimens/uihelper.dart';
import '../constants/values/colors.dart';

class ReusableButtonOutlined extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final Color? color;
  final double? widthPercent;
  const ReusableButtonOutlined({Key? key, required this.text, required this.onPressed, this.color, this.widthPercent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: UiHelper.verticalSymmetricPadding1x,
      child: SizedBox(
        height: height / 100 * 4,
        width: widthPercent != null ? width * widthPercent! : width,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            side: BorderSide(color: color ?? Colors.black),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          icon: Padding(
            padding: UiHelper.leftPadding1x,
            child: Text(
              'Değiştir',
              style: textTheme.button!.copyWith(color: color ?? Colors.black),
            ),
          ),
          label: Icon(
            Icons.chevron_right,
            color: color ?? Colors.black,
          ),
        ),
      ),
    );
  }
}
