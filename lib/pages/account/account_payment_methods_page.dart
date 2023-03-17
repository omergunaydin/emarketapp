import 'package:emarketapp/constants/dimens/uihelper.dart';
import 'package:emarketapp/constants/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AccountPaymentMethodsPage extends StatelessWidget {
  const AccountPaymentMethodsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Ödeme Yöntemlerim',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: UiHelper.allPadding3x,
              child: Text(
                'Online Ödeme',
                style: textTheme.subtitle2!.copyWith(color: Colors.grey),
              ),
            ),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: UiHelper.allPadding3x,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kartım HalkBank',
                              style: textTheme.subtitle2!.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '543081**********12',
                              style: textTheme.button!.copyWith(color: Colors.grey),
                            )
                          ],
                        ),
                        const Spacer(),
                        Container(
                          width: 60,
                          height: 35,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Image.asset(
                            'assets/images/mastercard.png',
                          ),
                        ),
                        Padding(
                          padding: UiHelper.leftPadding2x,
                          child: IconButton(onPressed: () {}, icon: const Icon(MdiIcons.deleteOutline)),
                        )
                      ],
                    ),
                  ),
                  const Padding(
                    padding: UiHelper.horizontalSymmetricPadding3x,
                    child: Divider(height: 1),
                  ),
                  Padding(
                    padding: UiHelper.allPadding3x,
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: UiColorHelper.mainBlue),
                          ),
                          child: InkWell(
                            onTap: () {},
                            child: const Icon(
                              Icons.add_outlined,
                              color: UiColorHelper.mainBlue,
                            ),
                          ),
                        ),
                        Padding(
                          padding: UiHelper.leftPadding4x,
                          child: Text(
                            'Başka Kart Ekle',
                            style: textTheme.subtitle2!.copyWith(fontWeight: FontWeight.bold, color: UiColorHelper.mainBlue),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: UiHelper.horizontalSymmetricPadding3x,
                    child: Divider(height: 1),
                  ),
                  Padding(
                    padding: UiHelper.allPadding3x,
                    child: Row(
                      children: [
                        SizedBox(
                          width: width * 0.60,
                          child: Text(
                            'Kart bilgileriniz MasterPass güvencesiyle saklanmaktadır. ',
                            style: textTheme.button!.copyWith(color: Colors.grey),
                          ),
                        ),
                        const Spacer(),
                        Image.asset(width: width * 0.27, height: width * 0.14, 'assets/images/masterpass.png')
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
