import 'package:emarketapp/constants/dimens/uihelper.dart';
import 'package:flutter/material.dart';

class Skelton extends StatelessWidget {
  const Skelton({Key? key, this.width, this.height}) : super(key: key);
  final double? height, width;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: UiHelper.allPadding1x,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.10),
          borderRadius: UiHelper.borderRadiusCircular3x,
        ),
      ),
    );
  }
}
