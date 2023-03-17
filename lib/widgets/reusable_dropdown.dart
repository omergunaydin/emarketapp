import 'package:flutter/material.dart';

class ReusableDropdown extends StatelessWidget {
  String? selectedItem;
  List<String> itemsList;
  Function(String?)? onChanged;
  bool? allWidth;
  ReusableDropdown({Key? key, required this.itemsList, required this.onChanged, this.selectedItem, this.allWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: allWidth != null ? width : width * 0.40,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey), color: Colors.white),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          dropdownColor: Colors.white,
          iconEnabledColor: Colors.black,
          isExpanded: true,
          value: selectedItem,
          items: itemsList.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
