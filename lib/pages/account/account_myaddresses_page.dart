import 'package:emarketapp/widgets/reusable_button.dart';
import 'package:emarketapp/widgets/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../constants/dimens/uihelper.dart';
import '../../constants/values/colors.dart';

class AccountMyAddresses extends StatefulWidget {
  AccountMyAddresses({Key? key}) : super(key: key);

  @override
  State<AccountMyAddresses> createState() => _AccountMyAddressesState();
}

class _AccountMyAddressesState extends State<AccountMyAddresses> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Adreslerim',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      bottomNavigationBar: Padding(
        padding: UiHelper.allPadding3x,
        child: ReusableButton(
          text: 'Yeni Adres Oluştur',
          onPressed: () {
            showSnackBar(
              context: context,
              msg: 'Not working on this demo App',
            );
          },
          color: UiColorHelper.mainBlue,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: UiHelper.allPadding3x,
            child: Text('Kayıtlı Teslimat Adreslerim', style: textTheme.subtitle2!.copyWith(color: Colors.grey)),
          ),
          const Divider(height: 2),
          Container(
            color: Colors.white,
            child: Padding(
              padding: UiHelper.allPadding3x,
              child: Row(
                children: [
                  const Icon(MdiIcons.navigationOutline, size: 16),
                  Padding(
                    padding: UiHelper.horizontalSymmetricPadding1x,
                    child: Text('Ev Adresim', style: textTheme.button!),
                  ),
                  Expanded(
                    child: Text(
                      'Sanayi Cad. 3C Fatih Mah. Deniz Sok. No:45 Beşikdüzü/Trabzon',
                      style: textTheme.button!.copyWith(color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(MdiIcons.noteEditOutline, size: 16)
                ],
              ),
            ),
          ),
          const Divider(height: 2),
          Container(
            color: Colors.white,
            child: Padding(
              padding: UiHelper.allPadding3x,
              child: Row(
                children: [
                  const Icon(MdiIcons.navigationOutline, size: 16),
                  Padding(
                    padding: UiHelper.horizontalSymmetricPadding1x,
                    child: Text('İş Adresim', style: textTheme.button!),
                  ),
                  Expanded(
                    child: Text(
                      'Merkez Cad. Vardallı Mah. Kara Sok. No:20, Beşikdüzü/Trabzon',
                      style: textTheme.button!.copyWith(color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(MdiIcons.noteEditOutline, size: 16)
                ],
              ),
            ),
          ),
          const Divider(height: 2),
          const SizedBox(height: 50),
          //TODO: Add Markets
          Padding(
            padding: UiHelper.allPadding3x,
            child: Text('Daha Önce Sipariş Verdiğim Marketler', style: textTheme.subtitle2!.copyWith(color: Colors.grey)),
          ),
          const Divider(height: 2),
          Container(
            color: Colors.white,
            child: Padding(
              padding: UiHelper.allPadding3x,
              child: Row(
                children: [
                  const Icon(MdiIcons.store, size: 16),
                  Padding(
                    padding: UiHelper.horizontalSymmetricPadding1x,
                    child: Text('İş Adresim', style: textTheme.button!),
                  ),
                  Expanded(
                    child: Text(
                      'Merkez Cad. Vardallı Mah. Kara Sok. No:20, Beşikdüzü/Trabzon',
                      style: textTheme.button!.copyWith(color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(MdiIcons.noteEditOutline, size: 16)
                ],
              ),
            ),
          ),
          const Divider(height: 2),
          Spacer(),
        ],
      ),
    );
  }
}
