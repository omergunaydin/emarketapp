import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../constants/dimens/uihelper.dart';
import '../../widgets/reusable_radiolisttile_delivery.dart';

class PageTomorrow extends StatefulWidget {
  String selectedDate;
  String selectedHour;
  Function function;
  PageTomorrow({Key? key, required this.selectedDate, required this.selectedHour, required this.function}) : super(key: key);

  @override
  State<PageTomorrow> createState() => _PageTomorrowState();
}

class _PageTomorrowState extends State<PageTomorrow> with AutomaticKeepAliveClientMixin {
  String selectedValue = '';
  late List<String> hoursList;

  @override
  void initState() {
    hoursList = getHoursList();
    if (getTomorrowDateString() == widget.selectedDate) {
      selectedValue = widget.selectedHour;
    } else {
      selectedValue = '';
    }
    super.initState();
  }

  List<String> getHoursList() {
    List<String> hoursList = [];
    DateTime startDate = DateTime(2023, 1, 1, 9, 0); // 9:00 AM
    DateTime endDate = DateTime(2023, 1, 1, 21, 0); // 21:00 PM
    int interval = 60; // 1 hour in minutes
    while (startDate.isBefore(endDate)) {
      DateTime endOfInterval = startDate.add(Duration(minutes: interval));
      String timeRange = "${DateFormat.Hm().format(startDate)}-${DateFormat.Hm().format(endOfInterval)}";
      hoursList.add(timeRange);
      startDate = endOfInterval;
    }
    return hoursList;
  }

  String getTomorrowDateString() {
    DateFormat dateFormat = DateFormat('dd MMMM y EEEE', 'tr_TR');
    DateTime now = DateTime.now();
    now = DateTime(now.year, now.month, now.day);
    DateTime nowPlusOne = now.add(const Duration(days: 1));
    String nowPlusOneString = dateFormat.format(nowPlusOne);
    return nowPlusOneString;
  }

  changeSelectedValue(val) {
    setState(() {
      selectedValue = (val as String);
      widget.selectedHour = selectedValue;
      widget.selectedDate = getTomorrowDateString();
      widget.function(widget.selectedDate, widget.selectedHour);
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Sabah
          Padding(
            padding: UiHelper.allPadding3x,
            child: Text(
              'Sabah',
              style: textTheme.subtitle1!.copyWith(color: Colors.grey),
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                CustomRadioListTile(value: hoursList[0], selectedValue: selectedValue, widget: widget, status: 'Uygun', text: hoursList[0], onChanged: changeSelectedValue),
                CustomRadioListTile(value: hoursList[1], selectedValue: selectedValue, widget: widget, status: 'Uygun', text: hoursList[1], onChanged: changeSelectedValue),
                CustomRadioListTile(value: hoursList[2], selectedValue: selectedValue, widget: widget, status: 'Uygun', text: hoursList[2], onChanged: changeSelectedValue),
              ],
            ),
          ),
          //Öğle
          Padding(
            padding: UiHelper.allPadding3x,
            child: Text(
              'Öğle',
              style: textTheme.subtitle1!.copyWith(color: Colors.grey),
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                CustomRadioListTile(value: hoursList[3], selectedValue: selectedValue, widget: widget, status: 'Uygun', text: hoursList[3], onChanged: changeSelectedValue),
                CustomRadioListTile(value: hoursList[4], selectedValue: selectedValue, widget: widget, status: 'Uygun', text: hoursList[4], onChanged: changeSelectedValue),
                CustomRadioListTile(value: hoursList[5], selectedValue: selectedValue, widget: widget, status: 'Uygun', text: hoursList[5], onChanged: changeSelectedValue),
                CustomRadioListTile(value: hoursList[6], selectedValue: selectedValue, widget: widget, status: 'Uygun', text: hoursList[6], onChanged: changeSelectedValue),
                CustomRadioListTile(value: hoursList[7], selectedValue: selectedValue, widget: widget, status: 'Uygun', text: hoursList[7], onChanged: changeSelectedValue),
              ],
            ),
          ),
          //Akşam
          Padding(
            padding: UiHelper.allPadding3x,
            child: Text(
              'Akşam',
              style: textTheme.subtitle1!.copyWith(color: Colors.grey),
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                CustomRadioListTile(value: hoursList[8], selectedValue: selectedValue, widget: widget, status: 'Uygun', text: hoursList[8], onChanged: changeSelectedValue),
                CustomRadioListTile(value: hoursList[9], selectedValue: selectedValue, widget: widget, status: 'Uygun', text: hoursList[9], onChanged: changeSelectedValue),
                CustomRadioListTile(value: hoursList[10], selectedValue: selectedValue, widget: widget, status: 'Uygun', text: hoursList[10], onChanged: changeSelectedValue),
                CustomRadioListTile(value: hoursList[11], selectedValue: selectedValue, widget: widget, status: 'Uygun', text: hoursList[11], onChanged: changeSelectedValue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
