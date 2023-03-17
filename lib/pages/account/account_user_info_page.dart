import 'package:emarketapp/constants/dimens/uihelper.dart';
import 'package:emarketapp/data/user_api_client.dart';
import 'package:emarketapp/widgets/reusable_app_bar.dart';
import 'package:emarketapp/widgets/reusable_button.dart';
import 'package:emarketapp/widgets/reusable_checkbox.dart';
import 'package:emarketapp/widgets/reusable_textfield.dart';
import 'package:emarketapp/widgets/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../constants/values/colors.dart';
import '../../cubit/user_cubit.dart';
import '../../models/myuser.dart';

class AccountUserInfoPage extends StatefulWidget {
  MyUser user;
  AccountUserInfoPage({Key? key, required this.user}) : super(key: key);

  @override
  State<AccountUserInfoPage> createState() => _AccountUserInfoPageState();
}

class _AccountUserInfoPageState extends State<AccountUserInfoPage> {
  var phoneMaskFormatter = MaskTextInputFormatter(mask: '+90(###) ###-##-##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);
  var phoneNumberTextController = TextEditingController();
  var nameTextController = TextEditingController();
  var emailTextController = TextEditingController();
  bool checkBox1State = false;
  bool checkBox2State = false;

  @override
  void initState() {
    super.initState();
    phoneNumberTextController.text = phoneMaskFormatter.maskText(widget.user.phoneNumber!);
    nameTextController.text = widget.user.name!;
    emailTextController.text = widget.user.email!;
    checkBox1State = widget.user.userAgreement!;
    checkBox2State = widget.user.offers!;
  }

  updateUserInfo(MyUser user) {
    UserApiClient().updateUserData(user);
    showSnackBar(context: context, msg: 'Bilgileriniz başarıyla kaydedildi.', type: 'success');
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: ReusableAppBar(text: 'KullanıcıBilgilerim', width: width, height: height),
      body: Padding(
        padding: UiHelper.horizontalSymmetricPadding4x,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            //Telefon Numarası TextField
            Text('Telefon', style: textTheme.subtitle2!.copyWith(fontWeight: FontWeight.bold)),
            ReusableTextField(
              controller: phoneNumberTextController,
              hintText: 'Telefon',
              inputFormatters: [phoneMaskFormatter],
            ),
            //Ad Soyad TextField
            Text('Ad Soyad', style: textTheme.subtitle2!.copyWith(fontWeight: FontWeight.bold)),
            ReusableTextField(controller: nameTextController, hintText: 'Ad Soyad'),
            //Email TextField
            Text('Email*', style: textTheme.subtitle2!.copyWith(fontWeight: FontWeight.bold)),
            ReusableTextField(controller: emailTextController, hintText: 'Email'),
            //Kullanım Koşulları ve Kampanya Onay Checkboxları
            ReusableCheckBox(
                text: 'Kullanım Koşullarını okudum, onaylıyorum.',
                checkBoxState: checkBox1State,
                onChanged: (val) {
                  setState(() {
                    checkBox1State = val!;
                  });
                }),
            ReusableCheckBox(
                text: 'Bana özel kampanyalardan email ve sms ile haberdar olmak istiyorum.',
                checkBoxState: checkBox2State,
                onChanged: (val) {
                  setState(() {
                    checkBox2State = val!;
                  });
                }),
            // Kaydet ve Hesabımı Sil Butonları
            ReusableButton(
                text: 'Kaydet',
                color: UiColorHelper.mainBlue,
                onPressed: () {
                  MyUser user = widget.user.copyWith(
                      name: nameTextController.text,
                      phoneNumber: '+90${phoneMaskFormatter.unmaskText(phoneNumberTextController.text)}',
                      email: emailTextController.text,
                      userAgreement: checkBox1State,
                      offers: checkBox2State);
                  updateUserInfo(user);
                }),
            ReusableButton(text: 'Hesabımı Sil', color: UiColorHelper.mainRed, onPressed: () async {}),
          ],
        ),
      ),
    );
  }
}
