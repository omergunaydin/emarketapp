import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/dimens/uihelper.dart';
import '../constants/values/colors.dart';

class ReusableTextField extends StatelessWidget {
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final String? hintText;
  final int? maxLines;
  ReusableTextField({Key? key, required this.controller, this.hintText, this.inputFormatters, this.maxLines}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: UiHelper.verticalSymmetricPadding2x,
      child: TextField(
        controller: controller,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          contentPadding: UiHelper.allPadding3x,
        ),
        maxLines: maxLines,
        style: Theme.of(context).textTheme.subtitle2,
        cursorColor: UiColorHelper.mainYellow,
      ),
    );
  }
}
