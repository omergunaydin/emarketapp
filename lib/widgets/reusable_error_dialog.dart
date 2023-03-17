import 'package:emarketapp/widgets/reusable_button.dart';
import 'package:flutter/material.dart';

import '../constants/dimens/uihelper.dart';
import '../constants/values/colors.dart';

class ReusableAlertDialog extends StatelessWidget {
  final String text;
  final String type;
  void Function()? onPressed;
  ReusableAlertDialog({Key? key, required this.text, required this.type, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      title: const Icon(Icons.error_outline, size: 36),
      content: Text(
        text,
        style: textTheme.subtitle2,
        textAlign: TextAlign.center,
      ),
      actions: [
        type == '1'
            ? Padding(
                padding: UiHelper.horizontalSymmetricPadding6x,
                child: ReusableButton(text: 'Tamam', color: UiColorHelper.mainBlue, onPressed: () => Navigator.of(context).pop()),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: UiHelper.rightPadding4x,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Vazgeç',
                        style: Theme.of(context).textTheme.button!.copyWith(decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  SizedBox(width: 100, child: ReusableButton(text: 'Evet', color: UiColorHelper.mainBlue, onPressed: onPressed)),
                ],
              )
      ],
    );
  }
}
