import 'package:emarketapp/pages/account/account_billing_info_individual_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'account_billing_info_corporate_page.dart';

class AccountBillingPageMain extends StatelessWidget {
  const AccountBillingPageMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fatura Bilgilerim',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: AccountBillingInfoIndividualPage())),
            child: const ListTile(
              title: Text('Bireysel'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          const Divider(height: 1),
          InkWell(
            onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: AccountBillingInfoCorporatePage())),
            child: const ListTile(
              title: Text('Kurumsal'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
