import 'package:emarketapp/constants/dimens/uihelper.dart';
import 'package:emarketapp/constants/values/colors.dart';
import 'package:emarketapp/pages/authentication/authentication_verify_code_page.dart';
import 'package:emarketapp/widgets/reusable_button.dart';
import 'package:emarketapp/widgets/reusable_textfield.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../../widgets/reusable_app_bar.dart';
import '../../widgets/reusable_error_dialog.dart';

class AuthenticationPage extends StatefulWidget {
  bool registered;
  AuthenticationPage({Key? key, required this.registered}) : super(key: key);

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final _phoneNumberController = TextEditingController();
  var phoneMaskFormatter = MaskTextInputFormatter(mask: '+90(###) ###-##-##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: ReusableAppBar(text: 'Üye Girişi', width: width, height: height),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Phone icon & info text
            Container(
              width: width,
              height: height * 0.30,
              color: UiColorHelper.mainYellow,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Icon(MdiIcons.cellphoneCheck, size: 65),
                  Text(
                    'Lütfen cep telefonu numaranızı giriniz.\nCep telefonunuza SMS ile gelecek olan\nkod ile giriş yapabileceksiniz.',
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            //Phone number text & textfield & button
            Padding(
              padding: UiHelper.horizontalSymmetricPadding3x,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cep Telefonunuz', style: textTheme.subtitle2!.copyWith(fontWeight: FontWeight.bold)),
                  ReusableTextField(controller: _phoneNumberController, inputFormatters: [phoneMaskFormatter], hintText: '+90(---)-------'),
                  ReusableButton(
                      text: 'Devam et',
                      onPressed: () {
                        //close keyboard
                        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                        //if phoneNumber lenght is less than 10 digits Show Error
                        if (phoneMaskFormatter.getUnmaskedText().toString().length < 10) {
                          showDialog(context: context, builder: (_) => ReusableAlertDialog(text: 'Geçerli bir telefon numarası giriniz!', type: '1'));
                          //if phoneNumber is ok --> Navigate to AuthenticationVerifyCodePage
                        } else {
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: AuthenticationVerifyCodePage(phoneNumber: '+90${phoneMaskFormatter.getUnmaskedText()}', registered: widget.registered),
                            ),
                          );
                        }
                      },
                      color: UiColorHelper.mainBlue),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
