import 'package:flutter/material.dart';

import '../constants/values/colors.dart';

class CustomRadioListTile extends StatelessWidget {
  Widget widget;
  String value;
  String selectedValue;
  String text;
  String status;
  Function(Object?)? onChanged;
  CustomRadioListTile({
    Key? key,
    required this.widget,
    required this.value,
    required this.selectedValue,
    required this.text,
    required this.status,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return RadioListTile(
      value: value,
      groupValue: selectedValue,
      onChanged: onChanged,
      activeColor: UiColorHelper.mainGreen,
      title: Row(
        children: [
          Text(text, style: textTheme.subtitle2!),
          const SizedBox(width: 10),
          Text(status, style: textTheme.button!.copyWith(color: UiColorHelper.mainGreen)),
          const Spacer(),
          Text('Ücretsiz', style: textTheme.subtitle1),
        ],
      ),
    );
  }
}
