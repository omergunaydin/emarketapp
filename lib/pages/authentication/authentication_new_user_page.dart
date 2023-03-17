import 'package:email_validator/email_validator.dart';
import 'package:emarketapp/constants/dimens/uihelper.dart';
import 'package:emarketapp/data/user_api_client.dart';
import 'package:emarketapp/widgets/reusable_button.dart';
import 'package:emarketapp/widgets/reusable_checkbox.dart';
import 'package:emarketapp/widgets/reusable_error_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../constants/values/colors.dart';
import '../../models/myuser.dart';
import '../../widgets/reusable_app_bar.dart';
import '../../widgets/reusable_textfield.dart';

class AuthenticationNewUserPage extends StatefulWidget {
  final String phoneNumber;
  const AuthenticationNewUserPage({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<AuthenticationNewUserPage> createState() => _AuthenticationNewUserPageState();
}

class _AuthenticationNewUserPageState extends State<AuthenticationNewUserPage> {
  FirebaseAuth mAuth = FirebaseAuth.instance;
  final _phoneNumberController = TextEditingController();
  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  bool checkBox1State = false;
  bool checkBox2State = false;

  var phoneMaskFormatter = MaskTextInputFormatter(mask: '+90(###) ###-##-##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);

  @override
  void initState() {
    super.initState();
    _phoneNumberController.text = widget.phoneNumber;
  }

  //CreateUser Function
  Future<void> createUser() async {
    MyUser newUser = MyUser(
        id: mAuth.currentUser?.uid,
        name: _nameTextController.text,
        email: _emailTextController.text,
        createdAt: DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch),
        phoneNumber: mAuth.currentUser?.phoneNumber,
        userAgreement: checkBox1State,
        offers: checkBox2State);
    await UserApiClient().addUserToDatabase(newUser).then((value) => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: ReusableAppBar(text: 'Yeni Kullanıcı', width: width, height: height),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //New User Icon
            Container(
              width: width,
              height: height * 0.2,
              color: UiColorHelper.mainYellow,
              child: const Icon(
                MdiIcons.account,
                size: 100,
              ),
            ),
            const SizedBox(height: 20),
            //New User Form
            Padding(
              padding: UiHelper.horizontalSymmetricPadding3x,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Phone Number TextField
                  Text('Cep Telefonunuz', style: textTheme.subtitle2!.copyWith(fontWeight: FontWeight.bold)),
                  ReusableTextField(controller: _phoneNumberController, inputFormatters: [phoneMaskFormatter], hintText: '+90(---)-------'),
                  //Name Surname TextField
                  Text('Ad Soyad', style: textTheme.subtitle2!.copyWith(fontWeight: FontWeight.bold)),
                  ReusableTextField(controller: _nameTextController),
                  //Name Surname TextField
                  Text('Email*', style: textTheme.subtitle2!.copyWith(fontWeight: FontWeight.bold)),
                  ReusableTextField(controller: _emailTextController),
                  //User Contract CheckBoxes
                  ReusableCheckBox(
                      text: 'Üyelik sözleşmesini okudum, onaylıyorum.',
                      checkBoxState: checkBox1State,
                      onChanged: (val) {
                        setState(() {
                          checkBox1State = val!;
                        });
                      }),
                  ReusableCheckBox(
                      text: 'Kişisel verilerin korunması kanunu kapsamında bilgilendirme metnini okudum, onaylıyorum.',
                      checkBoxState: checkBox2State,
                      onChanged: (val) {
                        setState(() {
                          checkBox2State = val!;
                        });
                      }),
                  //Create User Button
                  ReusableButton(
                      text: 'Üyelik Oluştur',
                      color: UiColorHelper.mainBlue,
                      onPressed: () {
                        //close keyboard
                        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                        //if phoneNumber lenght is less than 10 digits Show Error
                        if (_phoneNumberController.text.length < 13) {
                          showDialog(context: context, builder: (_) => ReusableAlertDialog(text: 'Geçerli bir telefon numarası giriniz!', type: '1'));
                        } else {
                          if (_nameTextController.text.isEmpty) {
                            showDialog(context: context, builder: (_) => ReusableAlertDialog(text: 'Ad Soyad alanı boş bırakılamaz!', type: '1'));
                          } else {
                            if (!EmailValidator.validate(_emailTextController.text)) {
                              showDialog(context: context, builder: (_) => ReusableAlertDialog(text: 'Geçerli bir email adresi giriniz!', type: '1'));
                            } else {
                              //Call Create user function
                              if (!checkBox1State) {
                                showDialog(context: context, builder: (_) => ReusableAlertDialog(text: 'Üyelik sözleşmesini onaylamalısınız!', type: '1'));
                              } else {
                                if (!checkBox2State) {
                                  showDialog(context: context, builder: (_) => ReusableAlertDialog(text: 'KVKK metnini onaylamalısınız!', type: '1'));
                                } else {
                                  createUser();
                                }
                              }
                            }
                          }
                        }
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
