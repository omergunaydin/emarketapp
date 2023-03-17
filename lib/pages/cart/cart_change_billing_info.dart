import 'package:emarketapp/constants/values/colors.dart';
import 'package:emarketapp/pages/account/account_billing_info_corporate_page.dart';
import 'package:emarketapp/widgets/reusable_button_outlined.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../account/account_billing_info_individual_page.dart';

class CartChangeBillingInfo extends StatefulWidget {
  String selectedBillingMethod;
  Function function;
  CartChangeBillingInfo({Key? key, required this.selectedBillingMethod, required this.function}) : super(key: key);

  @override
  State<CartChangeBillingInfo> createState() => _CartChangeBillingInfoState();
}

class _CartChangeBillingInfoState extends State<CartChangeBillingInfo> {
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selectedBillingMethod;
  }

  changeSelectedValue(val) {
    setState(() {
      selectedValue = val;
      widget.function(selectedValue);
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Fatura Bilgileri',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          children: [
            RadioListTile(
              value: 'Bireysel',
              groupValue: selectedValue,
              onChanged: changeSelectedValue,
              activeColor: UiColorHelper.mainGreen,
              title: Row(
                children: [
                  const Text('Bireysel'),
                  const Spacer(),
                  ReusableButtonOutlined(
                    text: 'Değiştir',
                    onPressed: () => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: AccountBillingInfoIndividualPage())),
                    color: UiColorHelper.mainGreen,
                    widthPercent: 0.30,
                  )
                ],
              ),
            ),
            RadioListTile(
              value: 'Kurumsal',
              groupValue: selectedValue,
              onChanged: changeSelectedValue,
              activeColor: UiColorHelper.mainGreen,
              title: Row(
                children: [
                  const Text('Kurumsal'),
                  const Spacer(),
                  ReusableButtonOutlined(
                    text: 'Değiştir',
                    onPressed: () => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: AccountBillingInfoCorporatePage())),
                    color: UiColorHelper.mainGreen,
                    widthPercent: 0.30,
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
