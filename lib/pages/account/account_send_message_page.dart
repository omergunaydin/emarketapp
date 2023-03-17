import 'package:emarketapp/constants/dimens/uihelper.dart';
import 'package:emarketapp/data/message_api_client.dart';
import 'package:emarketapp/data/user_api_client.dart';
import 'package:emarketapp/models/message.dart';
import 'package:emarketapp/models/myuser.dart';
import 'package:emarketapp/widgets/show_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/values/colors.dart';
import '../../widgets/reusable_button.dart';
import '../../widgets/reusable_dropdown.dart';
import '../../widgets/reusable_textfield.dart';

class AccountSendMessagePage extends StatefulWidget {
  AccountSendMessagePage({Key? key}) : super(key: key);

  @override
  State<AccountSendMessagePage> createState() => _AccountSendMessagePageState();
}

class _AccountSendMessagePageState extends State<AccountSendMessagePage> {
  FirebaseAuth mAuth = FirebaseAuth.instance;
  final List<String> _konuList = ['Mağazalar Hakkında', 'Max Market Hakkında', 'Siparişim Hakkında'];
  final List<String> _sorunuzList = ['Şikayet', 'Soru', 'Öneri', 'Memnuniyet'];
  String _secilenKonu = 'Mağazalar Hakkında';
  String _secilenSorunuz = 'Şikayet';
  final _mesajTextController = TextEditingController();

  changeSelectedKonu(val) {
    setState(() {
      _secilenKonu = val.toString();
    });
  }

  changeSelectedSorunuz(val) {
    setState(() {
      _secilenSorunuz = val.toString();
    });
  }

  void saveUserData() async {
    MyUser? user = await UserApiClient().fetchUserData(mAuth.currentUser!.uid);
    if (user != null) {
      Message message = Message(
        id: user.id,
        name: user.name,
        phoneNumber: user.phoneNumber,
        text: _mesajTextController.text,
        subject: _secilenKonu,
        type: _secilenSorunuz,
      );
      await MessageApiClient().addMessage(message);
      showSnackBar(context: context, msg: 'Mesajınız gönderildi!', type: 'success');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mesaj Gönder',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Top info area
            InkWell(
              onTap: () async {
                const phoneNumber = '+908508888888';
                final Uri launchUri = Uri(
                  scheme: 'tel',
                  path: phoneNumber,
                );
                await launchUrl(launchUri);
              },
              child: Container(
                width: width,
                height: 50,
                color: UiColorHelper.mainYellow.withAlpha(75),
                child: Center(
                  child: Row(
                    children: [
                      const Padding(
                        padding: UiHelper.horizontalSymmetricPadding3x,
                        child: Icon(Icons.phone),
                      ),
                      Text('Telefon Destek', style: textTheme.subtitle2!),
                      const SizedBox(width: 20),
                      Text('(0850) 888 88 88', style: textTheme.button!),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              width: width,
              child: Padding(
                padding: UiHelper.allPadding3x,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Konu', style: textTheme.subtitle2!.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ReusableDropdown(selectedItem: _secilenKonu, itemsList: _konuList, onChanged: changeSelectedKonu, allWidth: true),
                    const SizedBox(height: 20),
                    Text('Sorunuz', style: textTheme.subtitle2!.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ReusableDropdown(selectedItem: _secilenSorunuz, itemsList: _sorunuzList, onChanged: changeSelectedSorunuz, allWidth: true),
                    const SizedBox(height: 20),
                    Text('Mesajınız', style: textTheme.subtitle2!.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ReusableTextField(controller: _mesajTextController, maxLines: 3),
                    const SizedBox(height: 10),
                    ReusableButton(text: 'Gönder', onPressed: () => saveUserData(), color: UiColorHelper.mainBlue)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
